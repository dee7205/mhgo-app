import 'package:mhgo/features/survey/domain/entities/survey_entities.dart';
import 'package:mhgo/features/survey/domain/repositories/survey_repository.dart';

class SaveSurveyUseCase {
  final SurveyRepository repository;

  SaveSurveyUseCase(this.repository);

  Future<void> execute(Survey survey) {
    return repository.saveSurvey(survey);
  }
}
