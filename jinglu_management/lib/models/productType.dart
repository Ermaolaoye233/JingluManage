import 'package:equatable/equatable.dart';

part 'productType.g.dart';
class ProductType extends Equatable{
  ProductType({
    required this.id,
    required this.type,
});

  final int id;
  final String type;

  @override
  List<Object> get props => [id];

  factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
    id: json["id"],
    type: json['type'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
  };
}