class UserModel {
  final String uuid;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final String? token;
  final String? phoneNumber;
  final String? department;

  const UserModel({
    required this.uuid,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.token,
    this.phoneNumber,
    this.department,
  });

  UserModel copyWith({
    String? uuid,
    String? name,
    String? email,
    String? role,
    String? avatarUrl,
    String? token,
    String? phoneNumber,
    String? department,
  }) {
    return UserModel(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      token: token ?? this.token,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'token': token,
      'phoneNumber': phoneNumber,
      'department': department,
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
      phoneNumber: json['phoneNumber'] as String?,
      department: json['department'] as String?,
    );
  }
}
