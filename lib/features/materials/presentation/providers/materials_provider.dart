import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/isar_service.dart';
import '../../domain/repositories/materials_repository.dart';
import '../../data/repositories/materials_repository_impl.dart';
import '../../domain/entities/materials_entities.dart';

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

// Material Requests
final materialRequestsProvider = FutureProvider<List<MaterialRequestEntity>>((
  ref,
) async {
  final repo = ref.watch(materialsRepositoryProvider);
  return repo.getRequests();
});

// Project-Specific Material Requests
final projectMaterialRequestsProvider =
    FutureProvider.family<List<MaterialRequestEntity>, String>((
      ref,
      projectUuid,
    ) async {
      final repo = ref.watch(materialsRepositoryProvider);
      return repo.getRequestsForProject(projectUuid);
    });

// Deliveries
final deliveriesProvider = FutureProvider<List<DeliveryEntity>>((ref) async {
  final repo = ref.watch(materialsRepositoryProvider);
  return repo.getDeliveries();
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
    });
  }

  Future<void> saveRequest(MaterialRequestEntity request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.saveRequest(request);
      ref.invalidate(materialRequestsProvider);
      ref.invalidate(projectMaterialRequestsProvider(request.projectUuid));
    });
  }

  Future<void> deleteRequest(String uuid, String projectUuid) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.deleteRequest(uuid);
      ref.invalidate(materialRequestsProvider);
      ref.invalidate(projectMaterialRequestsProvider(projectUuid));
    });
  }

  Future<void> recordDelivery(DeliveryEntity delivery) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repo.recordDelivery(delivery);
      ref.invalidate(deliveriesProvider);
      ref.invalidate(materialsProvider);
    });
  }
}

final materialsNotifierProvider =
    AsyncNotifierProvider<MaterialsNotifier, void>(MaterialsNotifier.new);
