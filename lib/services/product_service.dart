import 'package:fake_shopcar/modles/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {
  final String baseUrl = "https://fakestoreapi.com/products";

  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception("API 請求失敗");
    }
  }

  Future<ProductModel> fetchProductById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("API 請求失敗");
    }
  }
}
