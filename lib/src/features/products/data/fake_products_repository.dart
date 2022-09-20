import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {

  

  
  final List<Product> _products = kTestProducts;
  
  List<Product> getProductsList(){
    return _products;
  }

  Product? getProduct(String id)
  {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<List<Product>> fetchProductsList() async{
   await Future.delayed(const Duration(seconds: 3));
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async*{
  
    await Future.delayed(const Duration(seconds: 1));
    yield _products;
  }


  // Stream<List<Product>> watchProductsList(){
  //   return Stream.value(_products);
  // }

  Stream<Product?> watchProduct(String id){
    return watchProductsList()
    .map((products) => products.firstWhere((product) => product.id == id));
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productsListStreamProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  
  
  final productsRepository = ref.watch(productsRepositoryProvider);  
  return productsRepository.watchProductsList();
});

final productsListFutureProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);  
  return productsRepository.fetchProductsList();
});

final productProvider = StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  final productsRepository = ref.watch(productsRepositoryProvider);  
  ref.onDispose(() {
     debugPrint('dispose productProvider $id');
  });
  return productsRepository.watchProduct(id);
});