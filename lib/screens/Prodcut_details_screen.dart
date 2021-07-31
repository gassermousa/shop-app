import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
class ProductDetails extends StatelessWidget {
   static String id='product_detail';
  //ProductDetails(this.title);
  @override
  Widget build(BuildContext context) {
    final productId= ModalRoute.of(context).settings.arguments as String; 
    final loadedproduct= Provider.of<Products>(context,listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedproduct.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            child: Hero(tag: loadedproduct.id,child: Image.network(loadedproduct.imageUrl,fit: BoxFit.cover,)),
          ),
          SizedBox(height: 10,),
          Text('\$${loadedproduct.price}',style: TextStyle(color: Colors.grey,fontSize: 20),),
          SizedBox(height: 10,),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(loadedproduct.description,
            textAlign: TextAlign.center,
            softWrap: true,
            ),
          )

        ],
      ),
      
    );
  }
}