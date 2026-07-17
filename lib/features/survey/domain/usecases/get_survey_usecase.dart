import 'package:mhgo/features/survey/domain/entities/survey_entities.dart';
import 'package:mhgo/features/survey/domain/repositories/survey_repository.dart';

class GetSurveyUseCase {
  final SurveyRepository repository;

  GetSurveyUseCase(this.repository);

  Future<List<Survey>> execute() {
    return repository.getAllSurveys();
  }
}
