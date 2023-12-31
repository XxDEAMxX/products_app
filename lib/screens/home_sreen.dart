import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final productsService = Provider.of<ProductsService>(context);

    if(productsService.isLoading) return const LoadingScreen();

    return  Scaffold(
      appBar: AppBar(
        title: const Text('productos'),
      ),
      body: ListView.builder(
        itemCount: productsService.product.length,
        itemBuilder: (context, index) => GestureDetector(
          child: ProductCard(product: productsService.product[index]),
          onTap: () {
            productsService.selectedProduct = productsService.product[index].copy();
            Navigator.pushNamed(context, 'product');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productsService.selectedProduct = new Product(
            available: false, 
            name: '', 
            price: 0.0
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}