import 'package:mhgo/features/auth/domain/entities/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> forgotPassword(String email);
  Future<UserModel?> getPersistedUser();
  Future<void> persistUser(UserModel user);
  Future<void> clearPersistedUser();
}
