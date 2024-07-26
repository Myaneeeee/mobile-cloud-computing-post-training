class Motorbike {
  final int id;
  final String name;
  final String price;
  final String description;
  final String imageUrl;

  Motorbike(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.imageUrl});

  factory Motorbike.fromJson(Map<String, dynamic> json) {
    return Motorbike(
      id: json['motorbikeId'],
      name: json['motorbikeName'],
      price: json['motorbikePrice'],
      description: json['motorbikeDescription'],
      imageUrl: json['motorbikeImage'],
    );
  }
}
