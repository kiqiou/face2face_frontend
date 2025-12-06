class MyUser {
  final int id;
  final String username;
  final String? phone;
  final String? avatarUrl;
  final int? role;

  MyUser({
    required this.id,
    required this.username,
    this.phone,
    this.avatarUrl,
    this.role,
  });

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      id: json['id'],
      username: json['username'],
      phone: json['phone'],
      avatarUrl: json['avatar_url'],
      role: json['role'],
    );
  }

  static final empty = MyUser(id: 0, username: '');
}
