import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/screens/productsOverview.dart';
import '../screens/Oreders_screen.dart';
import '../screens/userScreen_products.dart';
class Appdrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('gasser'),
            automaticallyImplyLeading: false,
            leading: IconButton(icon: Icon(Icons.cancel), onPressed:(){Navigator.pop(context);}),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop,color: Theme.of(context).primaryColor,),
            title: Text('Shop'),
            onTap: (){
             Navigator.pushNamed(context, ProductsOverViewScreen.id);
            },
          ),
          Divider(),
          ListTile(
             leading: Icon(Icons.payment,color: Theme.of(context).primaryColor,),
            title: Text('Orders'),
            onTap: (){
              Navigator.pushNamed(context, OrderScreen.id);
            },
          ),
          Divider(),
          ListTile(
             leading: Icon(Icons.edit,color: Theme.of(context).primaryColor,),
            title: Text('My products'),
            onTap: (){
              Navigator.pushNamed(context, UserProdctItems.id);
            },
          ),
          Divider(),
          ListTile(
             leading: Icon(Icons.exit_to_app,color: Theme.of(context).primaryColor,),
            title: Text('Logout'),
            onTap: (){
              Provider.of<Auth>(context,listen: false).logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      
    );
  }
}