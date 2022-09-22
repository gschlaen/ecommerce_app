import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/test_products.dart';
import '../domain/product.dart';

class FakeProductsRepository {
  FakeProductsRepository({this.addDelay = true});
  final bool addDelay;
  final List<Product> _products = kTestProducts;

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _getProduct(_products, id);
  }

  Future<List<Product>> fetchProductsList() async {
    await delay(addDelay);
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await delay(addDelay);
    // return Stream.value(_products);
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList().map((products) => _getProduct(products, id));
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

final productRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productsListStreamProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchProductsList();
});

final productsListFutureProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.fetchProductsList();
});

final productProvider = StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchProduct(id);
});
