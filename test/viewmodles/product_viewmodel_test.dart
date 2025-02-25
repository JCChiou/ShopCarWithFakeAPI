import 'package:fake_shopcar/modles/product_model.dart';
import 'package:fake_shopcar/repositories/product_repository.dart';
import 'package:fake_shopcar/viewmodels/product_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockProductRepository;
  late ProviderContainer container;

  setUp(() {
    mockProductRepository = MockProductRepository();
    // 把Repository替換為Mock
    container = ProviderContainer(overrides: [
      productRepositoryProvider.overrideWithValue(mockProductRepository)
    ]);
  });

  test('productListProvider should return ProductList', () async {
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
    when(() => mockProductRepository.getAllProducts())
        .thenAnswer((_) async => fakeProducts);
    final result = await container.read(productListProvider.future);
    expect(result, equals(fakeProducts));
  });
}
