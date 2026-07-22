import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/features/dar/data/repositories/dar_repository_impl.dart';
import 'package:mhgo/features/dar/domain/entities/dar_entities.dart';
import 'package:mhgo/features/dar/domain/repositories/dar_repository.dart';
import 'package:mhgo/features/dar/domain/usecases/get_dars_usecase.dart';
import 'package:mhgo/features/dar/domain/usecases/save_dar_usecase.dart';

import 'package:mhgo/core/database/isar_service.dart';

final darRepositoryProvider = Provider<DarRepository>((ref) {
  final isar = ref.watch(isarServiceProvider).isar;
  return DarRepositoryImpl(isar);
});

final getDarsUseCaseProvider = Provider<GetDarsUseCase>((ref) {
  final repo = ref.watch(darRepositoryProvider);
  return GetDarsUseCase(repo);
});

final saveDarUseCaseProvider = Provider<SaveDarUseCase>((ref) {
  final repo = ref.watch(darRepositoryProvider);
  return SaveDarUseCase(repo);
});

final darsListProvider = FutureProvider<List<DarReport>>((ref) async {
  final useCase = ref.watch(getDarsUseCaseProvider);
  return useCase.execute();
});

final darDetailsProvider = FutureProvider.family<DarReport?, String>((
  ref,
  id,
) async {
  final repo = ref.watch(darRepositoryProvider);
  return repo.getDarById(id);
});

// Presentation states for filtering, search and layout toggles
class DarSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void set(String val) => state = val;
  void clear() => state = '';
}

final darSearchQueryProvider = NotifierProvider<DarSearchQueryNotifier, String>(
  () {
    return DarSearchQueryNotifier();
  },
);

class DarProjectFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? val) => state = val;
}

final darProjectFilterProvider =
    NotifierProvider<DarProjectFilterNotifier, String?>(() {
      return DarProjectFilterNotifier();
    });

class DarStatusFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? val) => state = val;
}

final darStatusFilterProvider =
    NotifierProvider<DarStatusFilterNotifier, String?>(() {
      return DarStatusFilterNotifier();
    });

class DarDateFilterNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;
  void set(DateTime? val) => state = val;
  void clear() => state = null;
}

final darDateFilterProvider =
    NotifierProvider<DarDateFilterNotifier, DateTime?>(() {
      return DarDateFilterNotifier();
    });

class DarGridViewNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void toggle() => state = !state;
}

final darGridViewProvider = NotifierProvider<DarGridViewNotifier, bool>(() {
  return DarGridViewNotifier();
});
