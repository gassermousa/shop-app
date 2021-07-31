import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({this.id, this.title, this.quantity, this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemcount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;

    _items.forEach((key, cartitem) {
      total += cartitem.price * cartitem.quantity;
    });
    return total;
  }

  void addItem(
    String prodcutID,
    String title,
    double price,
  ) {
    if (_items.containsKey(prodcutID)) {
      _items.update(
          prodcutID,
          (x) => CartItem(
              id: x.id,
              title: x.title,
              price: x.price,
              quantity: x.quantity + 1));
    } else {
      _items.putIfAbsent(
          prodcutID,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeitem(String productID) {
    _items.remove(productID);
    notifyListeners();
  }

  void removesingleItem(String proID) {
    if (!_items.containsKey(proID)){ 
      return;
      }
    if (_items[proID].quantity > 1) {
      _items.update(
          proID,
          (x) => CartItem(
              id: x.id,
              price: x.price,
              quantity: x.quantity - 1,
              title: x.title));
    }
    else{
      _items.remove(proID);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
