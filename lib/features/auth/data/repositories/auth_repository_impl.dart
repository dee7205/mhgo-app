import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mhgo/features/auth/domain/entities/user_model.dart';
import 'package:mhgo/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const String _prefUserKey = 'auth_user_session';

  // Strict list of mock corporate accounts representing the 8 required roles
  static const Map<String, UserModel> _mockUsers = {
    'heiks@mhg.com': UserModel(
      uuid: 'user-dave-gigawin',
      name: 'Heike Garcia',
      email: 'heiks@mhg.com',
      role: 'Project Manager',
      avatarUrl: null,
      token: 'mock-session-token-dave',
    ),
    'engineer@mhg.com': UserModel(
      uuid: 'user-engineer-john',
      name: 'John Rey',
      email: 'engineer@mhg.com',
      role: 'Project Engineer',
      avatarUrl: null,
      token: 'mock-session-token-john',
    ),
    'leo@mhg.com': UserModel(
      uuid: 'user-leo-santos',
      name: 'Leo Santos',
      email: 'leo@mhg.com',
      role: 'QA/QC Engineer',
      avatarUrl: null,
      token: 'mock-session-token-leo',
    ),
    'warehouse@mhg.com': UserModel(
      uuid: 'user-mark-lim',
      name: 'Mark Lim',
      email: 'warehouse@mhg.com',
      role: 'Warehouse Personnel',
      avatarUrl: null,
      token: 'mock-session-token-mark',
    ),
    'procurement@mhg.com': UserModel(
      uuid: 'user-susan-co',
      name: 'Susan Co',
      email: 'procurement@mhg.com',
      role: 'Procurement Staff',
      avatarUrl: null,
      token: 'mock-session-token-susan',
    ),
    'om@mhg.com': UserModel(
      uuid: 'user-oscar-mendez',
      name: 'Oscar Mendez',
      email: 'om@mhg.com',
      role: 'O&M Engineer',
      avatarUrl: null,
      token: 'mock-session-token-oscar',
    ),
    'supervisor@mhg.com': UserModel(
      uuid: 'user-joyce-cruz',
      name: 'Joyce Cruz',
      email: 'supervisor@mhg.com',
      role: 'Site Supervisor',
      avatarUrl: null,
      token: 'mock-session-token-joyce',
    ),
    'mgmt@mhg.com': UserModel(
      uuid: 'user-manuel-gigawin',
      name: 'Manuel H. Gigawin',
      email: 'mgmt@mhg.com',
      role: 'Management',
      avatarUrl: null,
      token: 'mock-session-token-manuel',
    ),
  };

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final cleanEmail = email.trim().toLowerCase();

    if (password != 'password123') {
      throw Exception('Invalid email or password. Please use password123.');
    }

    if (_mockUsers.containsKey(cleanEmail)) {
      return _mockUsers[cleanEmail]!;
    } else {
      throw Exception(
        'Invalid email or password. Access is restricted to registered MHG accounts.',
      );
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final cleanEmail = email.trim().toLowerCase();

    if (!cleanEmail.endsWith('@mhg.com')) {
      throw Exception(
        'Email address must belong to the @mhg.com enterprise domain.',
      );
    }

    if (!_mockUsers.containsKey(cleanEmail)) {
      throw Exception(
        'This email is not registered in the MHG personnel database.',
      );
    }
  }

  @override
  Future<UserModel?> getPersistedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_prefUserKey);
    if (jsonStr != null) {
      try {
        final Map<String, dynamic> decoded =
            json.decode(jsonStr) as Map<String, dynamic>;
        return UserModel.fromJson(decoded);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> persistUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(user.toJson());
    await prefs.setString(_prefUserKey, jsonStr);
  }

  @override
  Future<void> clearPersistedUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefUserKey);
  }
}
