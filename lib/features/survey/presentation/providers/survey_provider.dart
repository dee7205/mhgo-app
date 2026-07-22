import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/core/database/isar_service.dart';
import 'package:mhgo/features/survey/data/repositories/survey_repository_impl.dart';
import 'package:mhgo/features/survey/domain/entities/survey_entities.dart';
import 'package:mhgo/features/survey/domain/repositories/survey_repository.dart';
import 'package:mhgo/features/survey/domain/usecases/get_survey_usecase.dart';
import 'package:mhgo/features/survey/domain/usecases/save_survey_usecase.dart';

final surveyRepositoryProvider = Provider<SurveyRepository>((ref) {
  final isar = ref.watch(isarServiceProvider).isar;
  return SurveyRepositoryImpl(isar);
});

final getSurveyUseCaseProvider = Provider<GetSurveyUseCase>((ref) {
  final repo = ref.watch(surveyRepositoryProvider);
  return GetSurveyUseCase(repo);
});

final saveSurveyUseCaseProvider = Provider<SaveSurveyUseCase>((ref) {
  final repo = ref.watch(surveyRepositoryProvider);
  return SaveSurveyUseCase(repo);
});

// --- Filtering & Sorting State Providers ---

class SurveySearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void set(String val) => state = val;
  void clear() => state = '';
}

final surveySearchQueryProvider =
    NotifierProvider<SurveySearchQueryNotifier, String>(() {
      return SurveySearchQueryNotifier();
    });

class SurveyStatusFilterNotifier extends Notifier<String> {
  @override
  String build() => 'All'; // 'All', 'Pending Survey', 'Quoted', 'Waiting Client', 'Approved', 'Declined', 'Converted'
  void set(String val) => state = val;
}

final surveyStatusFilterProvider =
    NotifierProvider<SurveyStatusFilterNotifier, String>(() {
      return SurveyStatusFilterNotifier();
    });

class SurveyGridViewNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void toggle() => state = !state;
  void set(bool val) => state = val;
}

final surveyGridViewProvider = NotifierProvider<SurveyGridViewNotifier, bool>(
  () {
    return SurveyGridViewNotifier();
  },
);

// --- Derived Providers ---

final surveyListProvider = FutureProvider<List<Survey>>((ref) async {
  final useCase = ref.watch(getSurveyUseCaseProvider);
  return useCase.execute();
});

final filteredSurveysProvider = Provider<AsyncValue<List<Survey>>>((ref) {
  final surveysAsync = ref.watch(surveyListProvider);
  final search = ref.watch(surveySearchQueryProvider);
  final status = ref.watch(surveyStatusFilterProvider);

  return surveysAsync.whenData((list) {
    var filtered = list.where((item) {
      if (search.isNotEmpty) {
        final query = search.toLowerCase();
        final matchesName = item.clientName.toLowerCase().contains(query);
        final matchesAddress = item.address.toLowerCase().contains(query);
        if (!matchesName && !matchesAddress) return false;
      }

      if (status != 'All' &&
          item.status.toLowerCase() != status.toLowerCase()) {
        return false;
      }

      return true;
    }).toList();

    return filtered;
  });
});

final surveyDetailsProvider = FutureProvider.family<Survey?, String>((
  ref,
  uuid,
) async {
  final repo = ref.watch(surveyRepositoryProvider);
  return repo.getSurveyByUuid(uuid);
});
