import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.isFav = false,
  });
  void _setfav(bool newval) {
    isFav = newval;
    notifyListeners();
  }

  Future<void> isVaf(String token,String userId ) async {
    final old = isFav;
    isFav = !isFav;
    notifyListeners();
    final url = 'https://my-sohp-default-rtdb.firebaseio.com/UserFavorites/$userId/$id.json?auth=$token';
    try {
      final res =
          await http.put(url, body: json.encode(isFav));

      if (res.statusCode >= 400) {
        _setfav(old);
      }
    } catch (e) {
      _setfav(old);
    }
  }
}
