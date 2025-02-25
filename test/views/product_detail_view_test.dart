import 'package:fake_shopcar/modles/product_model.dart';
import 'package:fake_shopcar/repositories/product_repository.dart';
import 'package:fake_shopcar/viewmodels/product_viewmodel.dart';
import 'package:fake_shopcar/views/ProductDetailView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_test_utils/image_test/image_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
  });

  testWidgets('應該顯示商品列表', (WidgetTester tester) async {
    final fakeProducts = ProductModel(
      id: 1,
      title: "測試商品",
      description: "這是測試商品",
      price: 99.99,
      image: "https://example.com/image.jpg",
      category: "electronics",
    );

    when(() => mockProductRepository.getProductById(1))
        .thenAnswer((_) async => fakeProducts);
    await tester.pumpWidget(ProviderScope(
        overrides: [
          productRepositoryProvider.overrideWithValue(mockProductRepository)
        ],
        child: MaterialApp(
          home: ProductDetailView(1),
        )));
    // 因為fake api 回傳網路圖片，所以使用 Mock network image來回傳fake image response
    await provideMockedNetworkImages(() async {
      await tester.pumpAndSettle();
    });
    expect(find.text('測試商品'), findsOneWidget);
    expect(find.text('這是測試商品'), findsOneWidget);
    expect(find.text('\$99.99'), findsOneWidget);
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);
    final Image imageWidget = tester.widget(imageFinder);
    expect((imageWidget.image as NetworkImage).url, equals("https://example.com/image.jpg"));
  });
}
