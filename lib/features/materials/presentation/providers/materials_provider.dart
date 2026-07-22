import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/isar_service.dart';
import '../../domain/repositories/materials_repository.dart';
import '../../data/repositories/materials_repository_impl.dart';
import '../../domain/entities/materials_entities.dart';
import 'package:mhgo/features/notifications/presentation/providers/notification_provider.dart';
final materialsRepositoryProvider = Provider<MaterialsRepository>((ref) {
  final isar = ref.watch(isarServiceProvider).isar;
  return MaterialsRepositoryImpl(isar);
});

// Materials List
final materialsProvider = FutureProvider<List<MaterialEntity>>((ref) async {
  final repo = ref.watch(materialsRepositoryProvider);
  return repo.getMaterials();
});

// Single Material Detail
final materialDetailsProvider = FutureProvider.family<MaterialEntity?, String>((
  ref,
  uuid,
) async {
  final repo = ref.watch(materialsRepositoryProvider);
  return repo.getMaterialById(uuid);
});

// Project-Specific Material Requirements
final projectMaterialRequirementsProvider =
    FutureProvider.family<List<ProjectMaterialRequirementEntity>, String>((
      ref,
      projectUuid,
    ) async {
      final repo = ref.watch(materialsRepositoryProvider);
      return repo.getRequirementsForProject(projectUuid);
    });

// Material-Specific Project Allocations
final materialAllocationsProvider =
    FutureProvider.family<List<ProjectMaterialRequirementEntity>, String>((
      ref,
      materialUuid,
    ) async {
      final repo = ref.watch(materialsRepositoryProvider);
      return repo.getRequirementsForMaterial(materialUuid);
    });

// Notifier for CRUD actions to auto-invalidate relevant states
class MaterialsNotifier extends AsyncNotifier<void> {
  late MaterialsRepository _repo;

  @override
  FutureOr<void> build() {
    _repo = ref.watch(materialsRepositoryProvider);
    return null;
  }

  Future<void> saveMaterial(MaterialEntity material) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.saveMaterial(material);
      ref.invalidate(materialsProvider);
      ref.invalidate(materialDetailsProvider(material.uuid));
    });
  }

  Future<void> deleteMaterial(String uuid) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.deleteMaterial(uuid);
      ref.invalidate(materialsProvider);
      // Since requirements cascaded, invalidate any project requirements we might have loaded
      // We can't invalidate all families easily, but any active view will rebuild or we can let Riverpod GC
    });
  }

  Future<void> saveRequirement(ProjectMaterialRequirementEntity req) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.saveRequirement(req);
      ref.invalidate(projectMaterialRequirementsProvider(req.projectUuid));
      ref.invalidate(materialAllocationsProvider(req.materialUuid));
      ref.invalidate(
        materialsProvider,
      ); // Allocations changed, stock might be affected implicitly
      ref.invalidate(materialDetailsProvider(req.materialUuid));

      ref.read(notificationProvider.notifier).createNotification(
        title: 'Material Requirement Updated',
        description: 'Material requirement has been allocated or updated for project.',
        type: 'material',
        relatedUuid: req.projectUuid,
        targetRoute: '/projects/${req.projectUuid}',
      );
    });
  }

  Future<void> deleteRequirement(String uuid, String projectUuid) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // We need the req before deleting to invalidate its material UUID
      final reqs = await _repo.getRequirementsForProject(projectUuid);
      final req = reqs.firstWhere((r) => r.uuid == uuid);

      await _repo.deleteRequirement(uuid);
      ref.invalidate(projectMaterialRequirementsProvider(projectUuid));
      ref.invalidate(materialAllocationsProvider(req.materialUuid));
      ref.invalidate(materialsProvider);
      ref.invalidate(materialDetailsProvider(req.materialUuid));

      ref.read(notificationProvider.notifier).createNotification(
        title: 'Material Requirement Removed',
        description: 'A material requirement was removed from the project.',
        type: 'material',
        relatedUuid: projectUuid,
        targetRoute: '/projects/$projectUuid',
      );
    });
  }
}

final materialsNotifierProvider =
    AsyncNotifierProvider<MaterialsNotifier, void>(MaterialsNotifier.new);
