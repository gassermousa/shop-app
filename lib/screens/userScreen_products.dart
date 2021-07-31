import 'package:flutter/material.dart';
import 'package:shop/provider/products.dart';
import '../Widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../Widgets/userproductitem.dart';
import '../screens/edit_product_screen.dart';

class UserProdctItems extends StatefulWidget {
  static const id= 'user_products_screen';
  


  @override
  _UserProdctItemsState createState() => _UserProdctItemsState();
}

class _UserProdctItemsState extends State<UserProdctItems> {
 /* Future <void>_refrsh(BuildContext context)async{
    await Provider.of<Products>(context).fetchproducts(true);
  }*/
  var _did = true;
  var isloading = false;
  
  @override
 
    void didChangeDependencies() {
    
    if (_did) {
      setState(() {
        isloading = true;
      });
      
      Provider.of<Products>(context,listen: false).fetchMYproducts().then((_) {
        setState(() {
          isloading = false;
        });
         
      });
    }

    _did = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your products '),
          actions: [IconButton(icon: Icon(Icons.add,color: Colors.white,), onPressed: (){
            Navigator.of(context).pushNamed(EidtProdcutScreen.id);
          })],
        ),
        drawer: Appdrawer(),
        body:isloading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : Consumer<Products>(
              builder: (context, product, _) =>
        ListView.builder(
          itemCount: product.mypro.length,
          itemBuilder: (ctx,i)=>Column(
            children:<Widget> [
              UserproductItem(
              product.mypro[i].id,
              product.mypro[i].title,
              product.mypro[i].imageUrl,
              product.mypro[i].price),
              Divider(),
            ],
          )
          )
          )
                  );
  }
}
