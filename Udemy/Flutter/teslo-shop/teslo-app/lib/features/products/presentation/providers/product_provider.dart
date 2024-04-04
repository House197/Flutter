import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_repository_provider.dart';

final productProvider = StateNotifierProvider.autoDispose.family<ProductsNotifier, ProductState, String>((ref, productId) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  // Este repositorio tiene el beneficio de que se refresca cuando se autentique el usuario, y el solo va a esparcir el token.
  return ProductsNotifier(
    productsRepository: productsRepository,
    productId: productId,
  );
});

class ProductsNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productsRepository;

  ProductsNotifier({
    required this.productsRepository,
    required String productId,
  }) : super(ProductState(id: productId)) {
    loadProduct();
  }

  Future<void> loadProduct() async {
    try {
      final product = await productsRepository.getProductById(state.id);
      // Gracias al autodispose esto es todo, ya que cuando se cierre y se busque otro producto los valores iniciales vuelven.
      state = state.copyWith(
        isLoading: false,
        product: product,
      );
    } catch (e) {
      print(e);
    }
  }
}

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving; // No se debe depender de esta funcionalidad, ya que el usuario en web puede refrescar la pantalla.

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ProductState(
        id: id ?? this.id,
        product: product ?? this.product,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
