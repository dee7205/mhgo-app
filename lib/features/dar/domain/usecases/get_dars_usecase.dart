import 'package:mhgo/features/dar/domain/entities/dar_entities.dart';
import 'package:mhgo/features/dar/domain/repositories/dar_repository.dart';

class GetDarsUseCase {
  final DarRepository repository;

  GetDarsUseCase(this.repository);

  Future<List<DarReport>> execute() {
    return repository.getDars();
  }
}
