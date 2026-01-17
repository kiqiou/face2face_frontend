class Procedure {
  final int id;
  final String name;
  final int price;
  final String duration;
  final int cosmetologistId;

  Procedure({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.cosmetologistId,
  });

  factory Procedure.fromJson(Map<String, dynamic> json) {
    final cosmoJson = json['cosmetologist'];
    return Procedure(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      duration: json['duration'],
      cosmetologistId: cosmoJson['id'],
    );
  }
}
