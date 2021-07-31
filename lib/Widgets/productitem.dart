import 'package:flutter/material.dart';
import 'package:shop/provider/Product.dart';
import 'package:shop/screens/Prodcut_details_screen.dart';
import 'package:provider/provider.dart';
import '../provider/Cart.dart';
import '../provider/auth.dart';

class Productitem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart= Provider.of<Cart>(context,listen: false);
    final auth=Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.id,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id,
                      child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
           builder: (context, product, _) => IconButton(
            onPressed: () async{
             await product.isVaf(auth.token,auth.userID);
            },
            color: Colors.deepOrange,
            icon: Icon(
              product.isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.deepOrange,
            ),
          ), 
           
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added item to cart!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(label: 'UNDO', onPressed: (){
                  cart.removesingleItem(product.id);
                }),
                )
                );
            },
            color: Colors.deepOrange,
          ),
        ),
      ),
    );
  }
}
