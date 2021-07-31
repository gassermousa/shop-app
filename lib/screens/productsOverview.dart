import 'package:flutter/material.dart';
import 'package:shop/Widgets/app_drawer.dart';
import 'package:shop/provider/Cart.dart';
import 'package:shop/provider/auth.dart';

import 'package:shop/screens/Cart_screnn.dart';
import '../Widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../Widgets/badge.dart';
import '../provider/products.dart';
import '../provider/Product.dart';
import 'Prodcut_details_screen.dart';

enum Filters { All, Fav, ProductsOverViewScreen }
List<String> searchlist = [];
List<String> ex = ['gasser'];

var showFav = false;
var len;

class ProductsOverViewScreen extends StatefulWidget {
  static String id = 'product_overview';
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _did = true;
  var isloading = false;
  var x;
  @override
  void didChangeDependencies() {
    if (_did) {
      setState(() {
        isloading = true;
      });

      Provider.of<Products>(context, listen: false).fetchproducts().then((_) {
        x = Provider.of<Products>(context, listen: false).itemcount;
        ///////* search *//////////rr
        for (int i = 0; i < x; i++) {
          searchlist.add(
              Provider.of<Products>(context, listen: false).items[i].title);
        }
        setState(() {
          isloading = false;
        });
        len = Provider.of<Products>(context).itemcount;
      });
    }

    _did = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer =Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        //title: Text('MyShop'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(context: context, delegate: Search());
              }),
          /* SizedBox(
            height: 50.0,
            width: 250.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (val){
                  setState(() {
                   Provider.of<Products>(context).findByname(val);
                    
                  });
                },
                enableSuggestions: true,
                style: TextStyle(color: Colors.white),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  hintText: 'Search..',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  
                ),
              ),
            ),
          )*/
          PopupMenuButton(
            onSelected: (Filters selectedvalue) {
              setState(() {
                if (selectedvalue == Filters.Fav) {
                  showFav = true;
                } else {
                  showFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: Filters.Fav,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: Filters.All,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemcount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.id);
              },
            ),
          ),
        ],
      ),
      drawer: Appdrawer(),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : ProductGrid(showFav, len),
    );
  }
}

class Search extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () {
          query = '';
        });
  }

  @override
  Widget buildLeading(BuildContext context) {
    IconButton(icon: Icon(Icons.arrow_back), onPressed: null);
  }

  @override
  Widget buildResults(BuildContext context) {
    final product =
        Provider.of<Products>(context, listen: false).findByname(query);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: Container(
            height: 200.0,
            width: 200.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: GridTile(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetails.id,
                        arguments: product.id);
                  },
                  child: Hero(
                    tag: product.id,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                footer: GridTileBar(
                  title: Text(
                    product.title,
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.black87,
                  /*leading: IconButton(
                    onPressed: () async {
                      await product.isVaf(auth.token, auth.userID);
                    },
                    color: Colors.deepOrange,
                    icon: Icon(
                      product.isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.deepOrange,
                    ),
                  ),*/
                  trailing: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      cart.addItem(product.id, product.title, product.price);
                      showDialog(
                        context: context,
                        builder: (cxt) => AlertDialog(
                          title: Icon(Icons.shopping_cart),
                          content: Text(
                              'Are you sure to Add ${product.title} to your cart'),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(cxt);
                                },
                                child: Text('OK')),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(cxt);
                                  cart.removesingleItem(product.id);
                                },
                                child: Text('NO'))
                          ],
                        ),
                      );
                    },
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ),
          ),
        ),
        FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (cxt) => AlertDialog(
                title: Icon(Icons.shopping_cart),
                content: Text(
                    'Are you sure to Add ${product.title} to your Favrites'),
                actions: [
                  FlatButton(
                      onPressed: () async {
                        Navigator.pop(cxt);
                        await product.isVaf(auth.token, auth.userID);
                      },
                      child: Text('OK')),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(cxt);
                      },
                      child: Text('NO'))
                ],
              ),
            );
          },
          label: Text(product.isFav ? 'already Favorite':'Favorite'),
          icon: Icon(product.isFav ? Icons.favorite : Icons.add),
          backgroundColor: Colors.deepOrange,
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = searchlist.where((element) {
      final productLower = element.toLowerCase();
      final queryLower = query.toLowerCase();
      return productLower.startsWith(queryLower);
    }).toList();

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final sug = suggestions[index];
          return ListTile(
            onTap: () {
              query = sug;
              showResults(context);
            },
            title: Text(sug),
          );
        });
  }
}
