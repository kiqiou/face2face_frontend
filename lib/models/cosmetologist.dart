class Cosmetologist {
  final int id;
  final String username;
  final String bio;
  final String specialization;
  final String? avatar;

  Cosmetologist({
    required this.id,
    required this.username,
    required this.bio,
    required this.specialization,
    this.avatar,
  });

  factory Cosmetologist.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    if (user == null) {
      throw Exception('User data is missing in Cosmetologist JSON');
    }

    return Cosmetologist(
      id: json['id'],
      username: user['username'] ?? 'Unknown',
      bio: json['bio'] ?? '',
      specialization: json['specializations'] ?? '',
      avatar: user['avatar_url'],
    );
  }
}
