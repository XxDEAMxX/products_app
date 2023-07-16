import 'package:flutter/material.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {

  const ProductScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final product = Provider.of<ProductsService>(context).selectedProduct;

    print(product.name);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: product.picture,),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(), 
                    icon: const Icon(Icons.arrow_back_ios_new, size: 40, color: Colors.white,), 
                  )
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () {
                      // TODO: Camara o galeria
                    }, 
                    icon: const Icon(Icons.photo_camera, size: 40, color: Colors.white,), 
                  )
                )
              ],
            ),

            _ProductForm(),

            SizedBox(height: 100,)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //TODO: Guardar producto
        },
        child: const Icon(Icons.save_outlined),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre',
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30,),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '\$150',
                  labelText: 'Precio',
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30,),

              SwitchListTile.adaptive(
                value: true, 
                title: Text('Diponible'),
                activeColor: Colors.indigo,
                onChanged: (value) {
                  
                },
              ),

              const SizedBox(height: 30,)
            ],
          )
        ),
        
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: const Offset(0, 5),
        blurRadius: 10
      )
    ]
  );
}