import 'dart:ui';

import 'package:flutter/material.dart';
import '../provider/Orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderr;
  OrderItem(this.orderr);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _exp = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),

      ),
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.orderr.amount.toStringAsFixed(2)}'),
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                  .format(widget.orderr.datetime)),
              trailing: IconButton(
                icon: Icon(_exp ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _exp = !_exp;
                  });
                },
              ),
            ),
            if (_exp)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                height: min(widget.orderr.products.length * 20.0 + 10, 100),
                child: ListView(
                  children: widget.orderr.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${prod.title}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${prod.quantity}x \$${prod.price}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey),
                              )
                            ],
                          ))
                      .toList(),
                ),
              )
          ],
        ));
  }
}
