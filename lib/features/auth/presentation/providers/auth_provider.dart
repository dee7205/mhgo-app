import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mhgo/features/auth/domain/entities/user_model.dart';
import 'package:mhgo/features/auth/domain/repositories/auth_repository.dart';
import 'package:mhgo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mhgo/features/auth/domain/usecases/login_usecase.dart';
import 'package:mhgo/features/auth/domain/usecases/forgot_password_usecase.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final bool forgotPasswordSuccess;

  AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.forgotPasswordSuccess = false,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool? forgotPasswordSuccess,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      forgotPasswordSuccess:
          forgotPasswordSuccess ?? this.forgotPasswordSuccess,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    _checkPersistedSession();
    return AuthState();
  }

  Future<void> _checkPersistedSession() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _repository.getPersistedUser();
      state = AuthState(user: user);
    } catch (_) {
      state = AuthState();
    }
  }

  Future<void> login(String email, String password, bool rememberMe) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await LoginUseCase(_repository).execute(email, password);
      if (rememberMe) {
        await _repository.persistUser(user);
      } else {
        await _repository.clearPersistedUser();
      }
      state = AuthState(user: user);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      forgotPasswordSuccess: false,
    );
    try {
      await ForgotPasswordUseCase(_repository).execute(email);
      state = state.copyWith(isLoading: false, forgotPasswordSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _repository.clearPersistedUser();
    state = AuthState();
  }

  Future<void> updateUser(UserModel updatedUser) async {
    await _repository.persistUser(updatedUser);
    state = state.copyWith(user: updatedUser);
  }

  void clearErrors() {
    state = state.copyWith(errorMessage: null, forgotPasswordSuccess: false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
