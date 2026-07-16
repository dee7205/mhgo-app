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
class MaterialsNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  final MaterialsRepository _repo;

  MaterialsNotifier(this._ref, this._repo) : super(const AsyncData(null));

  Future<void> saveMaterial(MaterialEntity material) async {
    state = const AsyncLoading();
    try {
      await _repo.saveMaterial(material);
      _ref.invalidate(materialsProvider);
      _ref.invalidate(materialDetailsProvider(material.uuid));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteMaterial(String uuid) async {
    state = const AsyncLoading();
    try {
      await _repo.deleteMaterial(uuid);
      _ref.invalidate(materialsProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> saveRequest(MaterialRequestEntity request) async {
    state = const AsyncLoading();
    try {
      await _repo.saveRequest(request);
      _ref.invalidate(materialRequestsProvider);
      _ref.invalidate(projectMaterialRequestsProvider(request.projectUuid));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteRequest(String uuid, String projectUuid) async {
    state = const AsyncLoading();
    try {
      await _repo.deleteRequest(uuid);
      _ref.invalidate(materialRequestsProvider);
      _ref.invalidate(projectMaterialRequestsProvider(projectUuid));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> recordDelivery(DeliveryEntity delivery) async {
    state = const AsyncLoading();
    try {
      await _repo.recordDelivery(delivery);
      _ref.invalidate(deliveriesProvider);
      _ref.invalidate(materialsProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final materialsNotifierProvider =
    StateNotifierProvider<MaterialsNotifier, AsyncValue<void>>((ref) {
      final repo = ref.watch(materialsRepositoryProvider);
      return MaterialsNotifier(ref, repo);
    });
