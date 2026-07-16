import 'package:mhgo/features/auth/domain/entities/user_model.dart';
import 'package:mhgo/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserModel> execute(String email, String password) {
    return repository.login(email, password);
  }
}
