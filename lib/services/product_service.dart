import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductsService extends ChangeNotifier{
  final String _baseUrl = 'futtler-varios-default-rtdb.firebaseio.com';
  final List<Product> product = [];
  late Product selectedProduct;

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

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

  Future saveOrCreateProduct( Product product ) async {
    isSaving = true;
    notifyListeners();

    if(product.id == null){
      await createProduct(product);
    }else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {

    final url = Uri.https( _baseUrl, 'products/${ product.id }.json' );
    final resp = await http.put( url, body: product.toJson2() );
    final decodedData = resp.body;

    final index = this.product.indexWhere((element) => element.id == product.id);
    this.product[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {

    final url = Uri.https( _baseUrl, 'products.json' );
    final resp = await http.post( url, body: product.toJson2() );
    final decodedData = json.decode(resp.body);

    product.id = decodedData['name'];
 
    this.product.add(product);

    return product.id!;
  }

  void updateSelectedProductImage(String path){
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if(newPictureFile == null) return null;
    
    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dbrtoo85j/image/upload?upload_preset=hnhkxlww');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url']; 
  }

}