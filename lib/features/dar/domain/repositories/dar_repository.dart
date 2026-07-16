import 'package:mhgo/features/dar/domain/entities/dar_entities.dart';

abstract class DarRepository {
  Future<List<DarReport>> getDars();
  Future<DarReport?> getDarById(String id);
  Future<void> saveDar(DarReport report);
  Future<void> deleteDar(String id);
}
