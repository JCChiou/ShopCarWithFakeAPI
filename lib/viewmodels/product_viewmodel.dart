import 'package:fake_shopcar/modles/product_model.dart';
import 'package:fake_shopcar/repositories/product_repository.dart';
import 'package:fake_shopcar/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final service = ref.read(productServiceProvider);
  return ProductRepository(service);
});

final productListProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repository = ref.read(productRepositoryProvider);
  return repository.getAllProducts();
});

final productDetailProvider =
FutureProvider.family<ProductModel, int>((ref, productId) async {
  final repository = ref.read(productRepositoryProvider);
  return repository.getProductById(productId);
});