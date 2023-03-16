import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/test_products.dart';
import '../../../localization/string_hardcoded.dart';
import '../../../utils/delay.dart';
import '../../../utils/in_memory_store.dart';
import '../domain/product.dart';

class FakeProductsRepository {
  FakeProductsRepository({this.addDelay = true});
  final bool addDelay;

  /// Preload with the default list of products when the app starts
  final _products = InMemoryStore<List<Product>>(List.from(kTestProducts));

  List<Product> getProductsList() {
    return _products.value;
  }

  Product? getProduct(String id) {
    return _getProduct(_products.value, id);
  }

  Future<List<Product>> fetchProductsList() async {
    await delay(addDelay);
    return Future.value(_products.value);
  }

  Stream<List<Product>> watchProductsList() {
    return _products.stream;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList().map((products) => _getProduct(products, id));
  }

  /// Updat product rating
  Future<void> updateProductRating({
    required ProductID productId,
    required double avgRating,
    required int numRatings,
  }) async {
    await delay(addDelay);
    final products = _products.value;
    final index = products.indexWhere((item) => item.id == productId);
    if (index == -1) {
      // if not found throw error
      throw StateError('Product not found (id: $productId)'.hardcoded);
    }
    products[index] = products[index].copyWith(
      avgRating: avgRating,
      numRatings: numRatings,
    );
    _products.value = products;
  }

  /// Search for products where the title contains the search query
  Future<List<Product>> searchProducts(String query) async {
    assert(
      _products.value.length <= 100,
      'Client-side search should only be performed if the number of products is small. '
      'Consider doing server-side search for larger datasets.',
    );
    // Get all products
    final productsList = await fetchProductsList();
    // Match all products where the title contains the query
    return productsList.where((product) => product.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  // * Set addDelay to false for faster loading
  return FakeProductsRepository(addDelay: false);
});

final productsListStreamProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  final productRepository = ref.watch(productsRepositoryProvider);
  return productRepository.watchProductsList();
});

final productsListFutureProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  final productRepository = ref.watch(productsRepositoryProvider);
  return productRepository.fetchProductsList();
});

final productProvider = StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  final productRepository = ref.watch(productsRepositoryProvider);
  return productRepository.watchProduct(id);
});

final productsListSearchProvider = FutureProvider.autoDispose.family<List<Product>, String>((ref, query) async {
  // ref.onDispose(() => debugPrint('disposed: $query'));
  // ref.onCancel(() => debugPrint('cancel: $query'));

  // Maintain results in cache for 5 sec. Then run autoDispose
  final link = ref.keepAlive();
  Timer(
    const Duration(seconds: 5),
    () => link.close(),
  );

  // await Future.delayed(const Duration(milliseconds: 500));
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.searchProducts(query);
});
