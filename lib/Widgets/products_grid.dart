import 'package:provider/provider.dart';


import '../Widgets/productitem.dart';
import 'package:flutter/material.dart';

import '../provider/products.dart';
class ProductGrid extends StatelessWidget {

  final int len;
 final bool showFavorites;
 
ProductGrid(this.showFavorites,this.len);


  @override
  Widget build(BuildContext context) {
    final productdata= Provider.of<Products>(context);
    final products= showFavorites ? productdata.favitems : productdata.items; 
    return len==0 ?Center(child: Text('No products to show'),):  GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (context,i)=>ChangeNotifierProvider.value(
        value:products[i]  ,
          child: Productitem(
          /* id: products[i].id,
          titel: products[i].title,
          imageurl: products[i].imageUrl, */
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10
      ),

    );
  }
}