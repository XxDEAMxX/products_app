import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier{
  final String _baseUrl = 'futtler-varios-default-rtdb.firebaseio.com';
  final List<Product> product = [];
  late Product selectedProduct;

  bool isLoading = true;

  ProductsService(){
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {

    isLoading = true;
    notifyListeners();

    final url = Uri.https( _baseUrl, 'products.json' );
    final resp = await http.get( url );
    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) { 
      final tempProduct = Product.fromJson(value);
      tempProduct.id = key;
      product.add(tempProduct);
    }); 

    isLoading = false;
    notifyListeners();

    return product;
  }



}