
import 'package:my_kom_delivery/module_dashbord/models/product_model.dart';

class CompanyModel {
  late final String id;
  late final String storeId;
  late final String name;
  late String description;
  late String imageUrl;
  late List<ProductModel> products;

  CompanyModel({required this.id, required this.name, required this.imageUrl,required this.description});

  CompanyModel.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.imageUrl = map['imageUrl'];
    this.description = map['description'];
    this.storeId = map['store_id'];
    if( map['products'] != null){
      List<ProductModel> productFromResponse = [];
      map['products'].forEach((v) {
        productFromResponse.add(ProductModel.fromJson(v));
      });
      this.products = productFromResponse;

    }else{
      this.products =[];

    }

  }

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['id'] = this.id;
    map['name'] = this.name;
    map['imageUrl'] = this.imageUrl;
    map['description'] = this.description;
    map['products'] = this.products.map((e) =>e.toJson()).toList();


    return map;
  }
}
