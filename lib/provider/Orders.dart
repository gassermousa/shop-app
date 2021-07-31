import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import './Cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;


  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.datetime});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;
  final String userId;
  Order(this.token,this.userId,this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }
  

  Future<void> fetchorders() async {
    final url = 'https://my-sohp-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$token';
    try {
      final response = await http.get(url);
      final extractdata = json.decode(response.body) as Map<String, dynamic>;
      print(json.decode(response.body));
      List<OrderItem> loaditem = [];
      if (extractdata != null) {
        extractdata.forEach((oderID, data) {
          loaditem.add(OrderItem(
              id: oderID,
              amount: data['amount'],
              datetime:DateTime.parse( data['datetime']),
              products: (data['products']as List<dynamic>).map((e) => CartItem(
                id: e['id'],
                price: e['price'],
                quantity: e['quantatiy'],
                title: e['title']
              )).toList()
             ));
          _orders = loaditem;
          notifyListeners();
        });
      } else {
        return;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addorders(List<CartItem> cartproducts, double total) async {
    var time = DateTime.now();
    final url = 'https://my-sohp-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$token';
    final res = await http.post(url,
        body: json.encode({
          'amount': total,
          'datetime': time.toIso8601String(),
          'products': cartproducts
              .map((e) => {
                    'id': e.id,
                    'quantatiy': e.quantity,
                    'price': e.price,
                    'title': e.title
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
          amount: total,
          datetime: time,
          products: cartproducts,
          id: json.decode(res.body)['name'],
        ));
    notifyListeners();
  }
}
