import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/Cart.dart';
import '../Widgets/Cart_items.dart' as ci;
import '../provider/Orders.dart';

class CartScreen extends StatelessWidget {
  static String id = 'Cart_screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Youe Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                 Spacer(),
                  Orderbtn(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemcount,
              itemBuilder: (ctx, i) => ci.CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].title),
            ),
          ),
        ],
      ),
    );
  }
}

class Orderbtn extends StatefulWidget {
  const Orderbtn({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderbtnState createState() => _OrderbtnState();
}

class _OrderbtnState extends State<Orderbtn> {
  var isload=false;
  @override
  Widget build(BuildContext context) {
    return isload ?CircularProgressIndicator(): FlatButton(
      child: Text('Order Now'),
      textColor: Theme.of(context).primaryColor,
      onPressed:(widget.cart.totalAmount<=0||isload) ? null : () async{
        setState(() {
          isload=true;
        });
       await Provider.of<Order>(context, listen: false).addorders(
            widget.cart.items.values.toList(), widget.cart.totalAmount);
            setState(() {
          isload=false;
        });
            widget.cart.clear(); 
        
      },
    );
  }
}
