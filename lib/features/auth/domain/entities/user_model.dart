class UserModel {
  final String uuid;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final String? token;

  const UserModel({
    required this.uuid,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'token': token,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      token: json['token'] as String?,
    );
  }
}
