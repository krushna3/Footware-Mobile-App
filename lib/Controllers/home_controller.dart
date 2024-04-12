import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footware/models/product_category/product_category.dart';
import 'package:get/get.dart';
import '../models/product/product.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  List<Product> products = [];
  List<Product> productShowInUi = [];
  List<ProductCategory> productCategories = [];

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('category');
    await fetchCategories();
    await fetchProducts();
    super.onInit();
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();

      final List<Product> retrivedProducts = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      products.clear();
      products.assignAll(retrivedProducts);
      productShowInUi.assignAll(products);

      Get.snackbar('Success', 'Product fetch successfully!',
          colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error fetching products', e.toString(),
          colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }

  fetchCategories() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();

      final List<ProductCategory> retrivedCategories = categorySnapshot.docs
          .map((doc) =>
              ProductCategory.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      productCategories.clear();
      productCategories.assignAll(retrivedCategories);
    } catch (e) {
      Get.snackbar('Error fetching products', e.toString(),
          colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }

  filterByCategory(String category) {
    productShowInUi.clear();
    productShowInUi =
        products.where((product) => product.category == category).toList();
    update();
  }

  filterByBrand(List<String> brands) {
    if (brands.isEmpty) {
      productShowInUi = products;
    } else {
      List<String> lowerCaseBrands =
          brands.map((brand) => brand.toLowerCase()).toList();
      productShowInUi = products
          .where((product) =>
              lowerCaseBrands.contains(product.brand?.toLowerCase()))
          .toList();
    }
    update();
  }

  sortByPrice({required bool ascending}) {
    List<Product> sortedProduct = List<Product>.from(productShowInUi);
    sortedProduct.sort((a, b) => ascending
        ? a.price!.compareTo(b.price!)
        : b.price!.compareTo(a.price!));

    productShowInUi = sortedProduct;
    update();
  }
}
