import 'dart:convert';
import 'dart:io';

import 'package:fake_shopcar/modles/product_model.dart';
import 'package:fake_shopcar/services/product_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../test_helper.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late ProductService productService;
  late MockHttpClient mockHttpClient;
  late Map<String, String> headers;

  setUpAll(() async {

    await setupTestEnv();
    // 🔹 註冊 Uri 的 fallback value，解決 `any<Uri>()` 的問題
    registerFallbackValue(FakeUri());
    headers = {'content-type': 'application/json; charset=utf-8'};
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    productService = ProductService(client: mockHttpClient);
  });

  test('取得商品列表時，回傳正確的Product List結構', () async {
    final Uri apiUri = Uri.parse("https://fakestoreapi.com/products");

    final fakeResponse = jsonEncode([
      {
        "id": 1,
        "title": "測試商品",
        "description": "這是測試商品",
        "price": 99.99,
        "image": "https://example.com/image.jpg",
        "category": "electronics"
      }
    ]);

    when(() => mockHttpClient.get(apiUri)).thenAnswer(
        (_) async => http.Response(fakeResponse, 200, headers: headers));
    final result = await productService.fetchProducts();
    expect(result, isA<List<ProductModel>>());
    expect(result.first.id, 1);
    expect(result.first.title, equals("測試商品")); // 🔹 確保 title 符合期待
    verify(() => mockHttpClient.get(apiUri)).called(1);
  });

  test('取得單一商品，回傳指定Json結構', () async {
    final Uri apiUri = Uri.parse("https://fakestoreapi.com/products/1");

    final fakeResponse = jsonEncode({
      "id": 1,
      "title": "測試商品",
      "description": "這是測試商品",
      "price": 99.99,
      "image": "https://example.com/image.jpg",
      "category": "electronics"
    });

    when(() => mockHttpClient.get(apiUri)).thenAnswer(
        (_) async => http.Response(fakeResponse, 200, headers: headers));

    final result = await productService.fetchProductById(1);
    expect(result, isA<ProductModel>());
    expect(result.id, 1);
    expect(result.title, equals('測試商品'));
    verify(() => mockHttpClient.get(apiUri)).called(1);
  });
}
