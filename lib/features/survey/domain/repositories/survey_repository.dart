import 'package:mhgo/features/survey/domain/entities/survey_entities.dart';

abstract class SurveyRepository {
  Future<List<Survey>> getAllSurveys();
  Future<Survey?> getSurveyByUuid(String uuid);
  Future<void> saveSurvey(Survey survey);
  Future<void> deleteSurvey(String uuid);
  Future<String?> convertToProject(Survey survey);
}
