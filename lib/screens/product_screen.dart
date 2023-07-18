import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:products_app/models/product.dart';
import 'package:products_app/providers/product_form_provider.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatelessWidget {

  const ProductScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final product = Provider.of<ProductsService>(context).selectedProduct;
    final productsService = Provider.of<ProductsService>(context);
    

    print(product.name);

    return ChangeNotifierProvider(
      create: (context) => ProductFormProvider(product),
      child: _productScreenBody(product: product, productsService: productsService,),
    );
  }
}

class _productScreenBody extends StatelessWidget {

  final ProductsService productsService;

  const _productScreenBody({
    super.key,
    required this.product, required this.productsService,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {

    final productFormProvider = Provider.of<ProductFormProvider>(context);
    
    return Scaffold(
      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    onPressed: () async {
                      
                      final ImagePicker picker = ImagePicker();
                      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

                      if (photo == null){
                        print('No selecciono nada');
                        return;
                      }

                      productsService.updateSelectedProductImage(photo.path);

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
        onPressed: () async {
          if( !productFormProvider.isValidForm()  ) return;

          final String? imageUrl = await productsService.uploadImage();

          print(imageUrl);

          await productsService.saveOrCreateProduct(productFormProvider.product);

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

    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
  
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: productForm.formKey,
          child: Column(
            children: [
              const SizedBox(height: 10,),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if( value == null || value.length < 1){
                    return 'El nombre es obligatorio';
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre',
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30,),
              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if(double.tryParse(value) == null){
                    product.price = 0;
                  }else {
                    product.price = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '\$150',
                  labelText: 'Precio',
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30,),

              SwitchListTile.adaptive(
                value: product.available, 
                title: Text('Diponible'),
                activeColor: Colors.indigo,
                onChanged: (value) {
                  productForm.updateAvailability(value);
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