import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class UserproductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;
  final double price;
  UserproductItem(this.id, this.title, this.imgUrl, this.price);
  @override
  Widget build(BuildContext context) {
   final scaffold =Scaffold.of(context);
    return ListTile(
      title: Text(title),
      subtitle: Text('\$${price.toString()}'),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.pushNamed(context, EidtProdcutScreen.id,
                      arguments: id);
                }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Text(
                              'Are you sure ?',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                                'Do you want to remove the item from the cart'),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                  child: Text('No')),
                              FlatButton(
                                  onPressed: () async {
                                      Navigator.of(ctx).pop(true);
                                    try {
                                      await Provider.of<Products>(context)
                                          .removeProduct(id);
                                    } catch (_) {
                                     
                                         scaffold.showSnackBar(SnackBar(
                                              content: Text(
                                        'Deleting failed!',
                                        textAlign: TextAlign.center,
                                      )));
                                    }
                                  },
                                  child: Text('Yes'))
                            ],
                            elevation: 10,
                          ));
                }),
          ],
        ),
      ),
    );
  }
}
