import 'package:mhgo/features/dar/domain/entities/dar_entities.dart';
import 'package:mhgo/features/dar/domain/repositories/dar_repository.dart';

class SaveDarUseCase {
  final DarRepository repository;

  SaveDarUseCase(this.repository);

  Future<void> execute(DarReport report) {
    return repository.saveDar(report);
  }
}
