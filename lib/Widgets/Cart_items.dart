import 'package:flutter/material.dart';

import '../provider/Cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productID;
  final double price;
  final int quan;
  final String title;
  CartItem(this.id, this.productID, this.price, this.quan, this.title);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
       return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    'Are you sure ?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text('Do you want to remove the item from the cart'),
                  actions: <Widget>[
                    FlatButton(onPressed: (){Navigator.of(ctx).pop(false);}, child: Text('No')),
                    FlatButton(onPressed: (){Navigator.of(ctx).pop(true);}, child: Text('Yes'))
                  ],
                  elevation: 10,
                ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeitem(productID);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('\$${(price * quan)}'),
            trailing: Text('$quan x'),
          ),
        ),
      ),
    );
  }
}
