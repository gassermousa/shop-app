import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop/provider/Product.dart';
import '../models/http_exp.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description:
          'A nice pair of trousers gasser A nice pair of trousers gasser A nice pair of trousers gasser A nice pair of trousers gasser A nice pair of trousers gasser A nice pair of trousers gasser A nice pair of trousers gasser A nice pair of trousers gasser A nice pair of trousers gasser A nice pair of trousers gasser.',
      price: 59.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2020/12/18/16/56/laptop-5842509_960_720.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Red Shirt',
      description: 'red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),*/
  ];
  final String token;
  final String userId;
  Products(this.token,this.userId,this._items);

  List<Product> get items {
    return [..._items];
  }
   List<Product> _mypro = [];

  List<Product> get mypro {
    return [..._mypro];
  }

  List<Product> get favitems {
    return _items.where((element) => element.isFav).toList();
  }

  Product findById(String id) {
    return items.firstWhere((prob) => prob.id == id);
  }

  Product findByname(String name) {
    return items.firstWhere((prob) => prob.title.toLowerCase().startsWith(name.toLowerCase()));
  }
  

  int get itemcount {
    return _items.length;
  }

  Future<void> fetchproducts([bool filter = false]) async {

    final filterstring= filter ? 'orderBy="creatorID"&equalTo="$userId"':'';
    try {
    
    var  url = 'https://my-sohp-default-rtdb.firebaseio.com/Products.json?auth=$token&$filterstring';
      final response = await http.get(url);
      final extractdata = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loaditem = [];
     url = 'https://my-sohp-default-rtdb.firebaseio.com/UserFavorites/$userId/.json?auth=$token';
     final favoriteres =await http.get(url);
     final favoritedata=json.decode(favoriteres.body);
      if (extractdata != null) {
        extractdata.forEach((prodID, proData) {
          loaditem.add(Product(
              id: prodID,
              description: proData['description'],
              imageUrl: proData['imageURL'],
              isFav:favoritedata==null? false : favoritedata[prodID] ?? false,
              price: proData['price'],
              title: proData['title']));
          _items = loaditem;
          notifyListeners();
        });
      } else {
        return;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addproduct(Product pro) async {
    final  url = 'https://my-sohp-default-rtdb.firebaseio.com/Products.json?auth=$token';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': pro.title,
          'description': pro.description,
          'price': pro.price,
          'imageURL': pro.imageUrl,
          'creatorID':userId
          //'isFavorite': pro.isFav
        }),
      );
      final newprod = Product(
          id: json.decode(response.body)['name'],
          description: pro.description,
          title: pro.title,
          price: pro.price,
          imageUrl: pro.imageUrl);
      _items.add(newprod);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateproduct(String id, Product prod) async {
    final index = _items.indexWhere((product) => product.id == id);
    final url = 'https://my-sohp-default-rtdb.firebaseio.com/Products/$id.json?auth=$token';
    await http.patch(url,
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'price': prod.price,
          'imageURL': prod.imageUrl,
        }));
    if (index >= 0) {
      _items[index] = prod;
      notifyListeners();
    } else {
      print('...');
    }
  }

  

  Future<void> removeProduct(String id)async {
    final url = 'https://my-sohp-default-rtdb.firebaseio.com/Products/$id.json?auth=$token';
    final prodindex=_items.indexWhere((element) => element.id == id);
    var product=_items[prodindex];
    _items.removeAt(prodindex);
      notifyListeners();
    final res=await http.delete(url);
    if(res.statusCode>=400){
      _items.insert(prodindex, product); 
      notifyListeners();
      throw Httpexp('Could not delete prodcut');
    }  
    product=null;
  
  }

  Future<void> fetchMYproducts() async {

    final filterstring= 'orderBy="creatorID"&equalTo="$userId"';
    try {
    
    var  url = 'https://my-sohp-default-rtdb.firebaseio.com/Products.json?auth=$token&$filterstring';
      final response = await http.get(url);
      final extractdata = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loaditem = [];
     url = 'https://my-sohp-default-rtdb.firebaseio.com/UserFavorites/$userId/.json?auth=$token';
     final favoriteres =await http.get(url);
     final favoritedata=json.decode(favoriteres.body);
      if (extractdata != null) {
        extractdata.forEach((prodID, proData) {
          loaditem.add(Product(
              id: prodID,
              description: proData['description'],
              imageUrl: proData['imageURL'],
              isFav:favoritedata==null? false : favoritedata[prodID] ?? false,
              price: proData['price'],
              title: proData['title']));
          _mypro = loaditem;
          notifyListeners();
        });
      } else {
        return;
      }
    } catch (error) {
      throw error;
    }
  }


}
