import 'package:flutter/material.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/screens/Prodcut_details_screen.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/productsOverview.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/userScreen_products.dart';
import './provider/products.dart';
import './provider/Cart.dart';
import './screens/Cart_screnn.dart';
import './provider/Orders.dart';
import './screens/Oreders_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products('', '', []),
            update: (context, auth, previous) => Products(auth.token,
                auth.userID, previous.items == null ? [] : previous.items),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: (_) => Order('', '', []),
            update: (context, auth, previous) => Order(auth.token, auth.userID,
                previous.orders == null ? [] : previous.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'My Shop',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                fontFamily: 'Lato',
                accentColor: Colors.deepOrange),
            home: auth.isauth
                ? ProductsOverViewScreen()
                : //FutureBuilder(
                    //future: auth.autologin(),
                    //builder: (ctx, snap) =>
                      //  snap.connectionState == ConnectionState.waiting
                        //    ? Center(child: Text('loading....'))
                             AuthScreen(),
            routes: {
              ProductDetails.id: (ctx) => ProductDetails(),
              CartScreen.id: (ctx) => CartScreen(),
              OrderScreen.id: (ctx) => OrderScreen(),
              ProductsOverViewScreen.id: (ctx) => ProductsOverViewScreen(),
              UserProdctItems.id: (ctx) => UserProdctItems(),
              EidtProdcutScreen.id: (ctx) => EidtProdcutScreen(),
            },
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text(
          'You have pushed the button this many times:',
        ),
      ),
    );
  }
}
