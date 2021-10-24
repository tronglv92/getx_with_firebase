import 'package:equatable/equatable.dart';

class ProductResponse extends Equatable {

  const ProductResponse({required this.name, required this.price});

  final String name;
  final int price;
  ProductResponse.fromJson(Map<String, dynamic> data)
      : name = data['name'] as String,
        price =data['price'] != null ? data['price'] as int : 0;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'price': price,

    };
  }
  @override
  // TODO: implement props
  List<Object?> get props => [name,price];

}