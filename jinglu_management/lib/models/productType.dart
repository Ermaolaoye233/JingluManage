part 'productType.g.dart';
class ProductType {
  ProductType({
    required this.id,
    required this.type,
});

  final int id;
  final String type;

  factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
    id: json["id"],
    type: json['type'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
  };
}