import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [

            _BackgroundImage( urlImage: product.picture,),
            
            _productDetails(product: product,),

            Positioned(
              top: 0,
              right: 0,
              child: _PriceTitle(product: product,),
            ),

            Positioned(
              top: 0,
              left: 0,
              child: _notAvailable(available: product.available,),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 7),
            blurRadius: 10
          )
        ]
      );
  }
}

class _notAvailable extends StatelessWidget {

  final bool available;

  const _notAvailable({
    super.key, required this.available,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(available ? 'Disponible': 'No Disponible', style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25))
      ),
    );
  }
}

class _PriceTitle extends StatelessWidget {

  final Product product;

  const _PriceTitle({
    super.key, required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('\$${product.price}' , style: TextStyle(color: Colors.white, fontSize: 20), )),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomLeft: Radius.circular(25))
      ),
    );
  }
}

class _productDetails extends StatelessWidget {

  final Product product;

  const _productDetails({
    super.key, required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        
        decoration: _DataBoxProduct(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name, 
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,), 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.id!, 
              style: TextStyle(fontSize: 15, color: Colors.white,)
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _DataBoxProduct() {
    return BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25))
      );
  }
}

class _BackgroundImage extends StatelessWidget {

  final String? urlImage;

  const _BackgroundImage({
    super.key, this.urlImage,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(urlImage != null ? urlImage! : 'https://via.placeholder.com/400x300/f6f6f6'),
          fit: BoxFit.cover
        ),
      ),
    );
  }
}