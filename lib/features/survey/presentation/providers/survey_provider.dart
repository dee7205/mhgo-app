import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/core/database/isar_service.dart';
import 'package:mhgo/features/survey/data/repositories/inspections_repository_impl.dart';
import 'package:mhgo/features/survey/domain/entities/survey_entities.dart';
import 'package:mhgo/features/survey/domain/repositories/survey_repository.dart';
import 'package:mhgo/features/survey/domain/usecases/get_survey_usecase.dart';
import 'package:mhgo/features/survey/domain/usecases/save_survey_usecase.dart';

final inspectionsRepositoryProvider = Provider<InspectionsRepository>((ref) {
  final isar = ref.watch(isarServiceProvider).isar;
  return InspectionsRepositoryImpl(isar);
});

final getInspectionsUseCaseProvider = Provider<GetInspectionsUseCase>((ref) {
  final repo = ref.watch(inspectionsRepositoryProvider);
  return GetInspectionsUseCase(repo);
});

final saveInspectionUseCaseProvider = Provider<SaveInspectionUseCase>((ref) {
  final repo = ref.watch(inspectionsRepositoryProvider);
  return SaveInspectionUseCase(repo);
});

final inspectionsListProvider = FutureProvider<List<InspectionReport>>((ref) async {
  final useCase = ref.watch(getInspectionsUseCaseProvider);
  return useCase.execute();
});

final inspectionDetailsProvider = FutureProvider.family<InspectionReport?, String>((ref, id) async {
  final repo = ref.watch(inspectionsRepositoryProvider);
  return repo.getInspectionById(id);
});

// --- Filtering & Sorting Presentation State Providers ---

class InspectionSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void set(String val) => state = val;
  void clear() => state = '';
}
final inspectionSearchQueryProvider = NotifierProvider<InspectionSearchQueryNotifier, String>(() {
  return InspectionSearchQueryNotifier();
});

class InspectionProjectFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? val) => state = val;
  void clear() => state = null;
}
final inspectionProjectFilterProvider = NotifierProvider<InspectionProjectFilterNotifier, String?>(() {
  return InspectionProjectFilterNotifier();
});

class InspectionTypeFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? val) => state = val;
  void clear() => state = null;
}
final inspectionTypeFilterProvider = NotifierProvider<InspectionTypeFilterNotifier, String?>(() {
  return InspectionTypeFilterNotifier();
});

class InspectionStatusFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? val) => state = val;
  void clear() => state = null;
}
final inspectionStatusFilterProvider = NotifierProvider<InspectionStatusFilterNotifier, String?>(() {
  return InspectionStatusFilterNotifier();
});

class InspectionInspectorFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? val) => state = val;
  void clear() => state = null;
}
final inspectionInspectorFilterProvider = NotifierProvider<InspectionInspectorFilterNotifier, String?>(() {
  return InspectionInspectorFilterNotifier();
});

class InspectionDateFilterNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;
  void set(DateTime? val) => state = val;
  void clear() => state = null;
}
final inspectionDateFilterProvider = NotifierProvider<InspectionDateFilterNotifier, DateTime?>(() {
  return InspectionDateFilterNotifier();
});

class InspectionSortFilterNotifier extends Notifier<String> {
  @override
  String build() => 'date_desc'; // 'date_desc' | 'date_asc' | 'priority_desc' | 'priority_asc'
  void set(String val) => state = val;
}
final inspectionSortFilterProvider = NotifierProvider<InspectionSortFilterNotifier, String>(() {
  return InspectionSortFilterNotifier();
});

class InspectionGridViewNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void toggle() => state = !state;
  void set(bool val) => state = val;
}
final inspectionGridViewProvider = NotifierProvider<InspectionGridViewNotifier, bool>(() {
  return InspectionGridViewNotifier();
});

// --- Derived Filtered Inspections List Provider ---

final filteredInspectionsProvider = Provider<AsyncValue<List<InspectionReport>>>((ref) {
  final inspectionsAsync = ref.watch(inspectionsListProvider);
  final search = ref.watch(inspectionSearchQueryProvider);
  final project = ref.watch(inspectionProjectFilterProvider);
  final type = ref.watch(inspectionTypeFilterProvider);
  final status = ref.watch(inspectionStatusFilterProvider);
  final inspector = ref.watch(inspectionInspectorFilterProvider);
  final date = ref.watch(inspectionDateFilterProvider);
  final sort = ref.watch(inspectionSortFilterProvider);

  return inspectionsAsync.whenData((list) {
    var filtered = list.where((item) {
      if (search.isNotEmpty) {
        final query = search.toLowerCase();
        final matchesTitle = item.title.toLowerCase().contains(query);
        final matchesInspector = item.inspectorName.toLowerCase().contains(query);
        final matchesId = item.inspectionId.toLowerCase().contains(query);
        final matchesLoc = item.location.toLowerCase().contains(query);
        if (!matchesTitle && !matchesInspector && !matchesId && !matchesLoc) {
          return false;
        }
      }
      
      if (project != null && item.projectUuid != project) {
        return false;
      }
      
      if (type != null && item.inspectionType.toLowerCase() != type.toLowerCase()) {
        return false;
      }
      
      if (status != null && item.status.toLowerCase() != status.toLowerCase()) {
        return false;
      }
      
      if (inspector != null && item.inspectorName.toLowerCase() != inspector.toLowerCase()) {
        return false;
      }
      
      if (date != null) {
        if (item.inspectionDate.year != date.year ||
            item.inspectionDate.month != date.month ||
            item.inspectionDate.day != date.day) {
          return false;
        }
      }
      
      return true;
    }).toList();

    if (sort == 'date_asc') {
      filtered.sort((a, b) => a.inspectionDate.compareTo(b.inspectionDate));
    } else if (sort == 'date_desc') {
      filtered.sort((a, b) => b.inspectionDate.compareTo(a.inspectionDate));
    } else if (sort == 'priority_desc') {
      filtered.sort((a, b) => _priorityValue(b.priority).compareTo(_priorityValue(a.priority)));
    } else if (sort == 'priority_asc') {
      filtered.sort((a, b) => _priorityValue(a.priority).compareTo(_priorityValue(b.priority)));
    }

    return filtered;
  });
});

int _priorityValue(String priority) {
  switch (priority.toLowerCase()) {
    case 'critical':
      return 4;
    case 'high':
      return 3;
    case 'medium':
      return 2;
    case 'low':
      return 1;
    default:
      return 0;
  }
}
