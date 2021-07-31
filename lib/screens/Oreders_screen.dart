import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/Orders.dart' show Order;
import '../Widgets/Oreder_item.dart';

class OrderScreen extends StatelessWidget {
  static String id = 'order_screen';
  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Order>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
        ),
        body: FutureBuilder(
          future: Provider.of<Order>(context, listen: false).fetchorders(),
          builder: (ctx, datasnapshot) {
            if (datasnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (datasnapshot.error != null) {
                return Center(
                  child: Text('No Orders'),
                );
              } else {
                return Consumer<Order>(
                  builder: (ctx, orderData, child) =>
                      orderData.orders.length == 0
                          ? Center(
                              child: Text('No Orders '),
                            )
                          : ListView.builder(
                              itemCount: orderData.orders.length,
                              
                              itemBuilder: (ctx, i) =>
                                  OrderItem(orderData.orders[i])),
                );
              }
            }
          },
        ));
  }
}
