import 'package:fake_shopcar/modles/product_model.dart';
import 'package:fake_shopcar/services/product_service.dart';

class ProductRepository {
  final ProductService apiService;

  ProductRepository(this.apiService);

  Future<List<ProductModel>> getAllProducts() => apiService.fetchProducts();

  Future<ProductModel> getProductById(int id) => apiService.fetchProductById(id);
}
