import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/fake_products_repository.dart';
import '../../domain/product.dart';

final productsSearchQueryStateProvider = StateProvider<String>((ref) {
  return '';
});

final productsSearchResultsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final searchQuery = ref.watch(productsSearchQueryStateProvider);
  return ref.watch(productsListSearchProvider(searchQuery).future);
});
