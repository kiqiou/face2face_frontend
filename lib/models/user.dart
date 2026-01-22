class MyUser {
  final int id;
  final String username;
  final String? phone;
  final String? avatarUrl;
  final int? role;
  final int? cosmetologistId;

  MyUser({
    required this.id,
    required this.username,
    this.phone,
    this.avatarUrl,
    this.role,
    this.cosmetologistId,
  });

  factory MyUser.fullFromJson(Map<String, dynamic> json) {
    return MyUser(
      id: json['user']['id'],
      username: json['user']['username'],
      phone: json['user']['phone'],
      avatarUrl: json['user']['avatar_url'],
      role: json['user']['role'],
      cosmetologistId: json['cosmetologist_profile']?['id'],
    );
  }

  factory MyUser.simpleFromJson(Map<String, dynamic> json) {
    return MyUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      phone: json['phone'],
      avatarUrl: json['avatar_url'],
      role: json['role'],
    );
  }

  static final empty = MyUser(id: 0, username: '', cosmetologistId: 0);

}
