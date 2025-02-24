import 'package:fake_shopcar/modles/product_model.dart';
import 'package:fake_shopcar/repositories/product_repository.dart';
import 'package:fake_shopcar/services/product_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductService extends Mock implements ProductService {}

void main() {
  late ProductRepository productRepository;
  late MockProductService mockProductService;

  setUp(() {
    mockProductService = MockProductService();
    productRepository = ProductRepository(mockProductService);
  });

  test('get All Product should return Product List', () async {
    final fakeProducts = [
      ProductModel(
        id: 1,
        title: "測試商品",
        description: "這是測試商品",
        price: 99.99,
        image: "https://example.com/image.jpg",
        category: "electronics",
      )
    ];
    when(() => mockProductService.fetchProducts())
        .thenAnswer((_) async => fakeProducts);

    final result = await productRepository.getAllProducts();
    expect(result, equals(fakeProducts));
    verify(() => productRepository.getAllProducts()).called(1);
    expect(result.length, 1);
  });

  test('get Product id 1 should return Product where id is 1', () async {
    final fakeProduct = ProductModel(
      id: 1,
      title: "測試商品",
      description: "這是測試商品",
      price: 99.99,
      image: "https://example.com/image.jpg",
      category: "electronics",
    );
    when(() => mockProductService.fetchProductById(1))
        .thenAnswer((_) async => fakeProduct);
    final result = await productRepository.getProductById(1);
    expect(result.id, equals(1));
    verify(() => productRepository.getProductById(1)).called(1);
  });

}
