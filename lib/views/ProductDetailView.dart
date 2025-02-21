import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/product_viewmodel.dart';

class ProductDetailView extends ConsumerWidget {
  final int productId;

  const ProductDetailView(this.productId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(productId);

    final productProvider = ref.watch(productDetailProvider(productId));

    return Scaffold(
      appBar: AppBar(title: Text('商品詳情')),
      body: productProvider.when(
        data: (product) => Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.network(product.image, height: 200),
              SizedBox(height: 16),
              Text(product.title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("\$${product.price}",
                  style: TextStyle(fontSize: 18, color: Colors.green)),
              SizedBox(height: 16),
              Text(product.description),
            ],
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("載入失敗: $err")),
      ),
    );
  }
}
