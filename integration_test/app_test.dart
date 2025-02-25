import 'package:fake_shopcar/views/ProductListview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end to end test', () {
    testWidgets('點擊第一個產品流程測試', (WidgetTester tester) async {
      await tester.pumpWidget(
          ProviderScope(
              child: MaterialApp(
                  home: ProductListView()
              )
          )
      );
      await tester.pumpAndSettle();
      // 🔹 確保商品列表已載入
      expect(find.text('Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops'), findsOneWidget);
      await tester.tap(find.text("Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops"));
      await tester.pumpAndSettle(); // ✅ 等待頁面轉換完成
      // 🔹 確保進入商品詳情頁
      // expect(find.text("這是測試商品的描述"), findsOneWidget);
      expect(find.text("\$109.95"), findsOneWidget);
    });
  });
}
