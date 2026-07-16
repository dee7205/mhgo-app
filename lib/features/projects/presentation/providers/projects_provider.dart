import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/core/database/isar_service.dart';
import 'package:mhgo/core/database/models/project_model.dart';
import 'package:mhgo/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:mhgo/features/projects/domain/entities/projects_entities.dart';
import 'package:mhgo/features/projects/domain/repositories/projects_repository.dart';
import 'package:mhgo/features/projects/domain/usecases/get_project_details_usecase.dart';
import 'package:mhgo/features/projects/domain/usecases/get_projects_usecase.dart';

final projectsRepositoryProvider = Provider<ProjectsRepository>((ref) {
  final isar = ref.watch(isarServiceProvider).isar;
  return ProjectsRepositoryImpl(isar);
});

final getProjectsUseCaseProvider = Provider<GetProjectsUseCase>((ref) {
  final repo = ref.watch(projectsRepositoryProvider);
  return GetProjectsUseCase(repo);
});

final getProjectDetailsUseCaseProvider = Provider<GetProjectDetailsUseCase>((ref) {
  final repo = ref.watch(projectsRepositoryProvider);
  return GetProjectDetailsUseCase(repo);
});

final projectsListProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final useCase = ref.watch(getProjectsUseCaseProvider);
  return useCase.execute();
});

final projectDetailsProvider = FutureProvider.family<DetailedProjectData, String>((ref, uuid) async {
  final useCase = ref.watch(getProjectDetailsUseCaseProvider);
  return useCase.execute(uuid);
});

// Presentation states for filtering, search, sorting and display mode using modern Riverpod Notifiers
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void set(String val) => state = val;
  void clear() => state = '';
}
final projectsSearchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(() {
  return SearchQueryNotifier();
});

class FilterStatusNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? val) => state = val;
}
final projectsFilterStatusProvider = NotifierProvider<FilterStatusNotifier, String?>(() {
  return FilterStatusNotifier();
});

class SortNotifier extends Notifier<String> {
  @override
  String build() => 'name';
  void set(String val) => state = val;
}
final projectsSortProvider = NotifierProvider<SortNotifier, String>(() {
  return SortNotifier();
});

class GridViewNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void toggle() => state = !state;
}
final projectsGridViewProvider = NotifierProvider<GridViewNotifier, bool>(() {
  return GridViewNotifier();
});
