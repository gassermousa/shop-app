import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/productsOverview.dart';
import '../provider/Product.dart';

class EidtProdcutScreen extends StatefulWidget {
  static const id = 'eidt_product_screen';
  @override
  _EidtProdcutScreenState createState() => _EidtProdcutScreenState();
}

class _EidtProdcutScreenState extends State<EidtProdcutScreen> {
  final _pricefoucsnode = FocusNode();
  final _descrpfoucs = FocusNode();
  final _imagfocus = FocusNode();
  final _imagctrl = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _newitem =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');
  @override
  void initState() {
    _imagfocus.addListener(() {
      updateimg();
    });
    super.initState();
  }

  var isInit = true;
  var isload = false;
  var initValues = {'title': '', 'desc': '', 'price': ''};

  @override
  void didChangeDependencies() {
    if (isInit) {
      final prodID = ModalRoute.of(context).settings.arguments as String;
      if (prodID != null) {
        final prod =
            Provider.of<Products>(context, listen: false).findById(prodID);
        _newitem = prod;
        initValues = {
          'title': _newitem.title,
          'desc': _newitem.description,
          'price': _newitem.price.toString()
        };
        _imagctrl.text = _newitem.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imagfocus.removeListener(() {
      updateimg();
    });
    _imagfocus.dispose();
    _pricefoucsnode.dispose();
    _descrpfoucs.dispose();
    _imagctrl.dispose();

    super.dispose();
  }

  void updateimg() {
    setState(() {});
  }

  Future<void> _saveform() async {
    final isvalid = _form.currentState.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isload = true;
    });
    if (_newitem.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateproduct(_newitem.id, _newitem);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addproduct(_newitem);
      } catch (erorr) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text('Some thing went wrong'),
            title: Text('An error ouccerred!'),
            actions: <Widget>[
              FlatButton(
                child: Text('ok'),
                onPressed: () {
                  Navigator.pushNamed(context, ProductsOverViewScreen.id);
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      isload = false; 
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveform();
              })
        ],
      ),
      body: isload
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(17.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      //  ___________________    1   _________________///
                      TextFormField(
                        initialValue: initValues['title'],
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Invalid Input';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_pricefoucsnode);
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _newitem = Product(
                            title: value,
                            id: _newitem.id,
                            isFav: _newitem.isFav,
                            description: _newitem.description,
                            price: _newitem.price,
                            imageUrl: _newitem.imageUrl,
                          );
                        },
                      ),
                      SizedBox(
                        height: 11.0,
                      ),

                      //  ___________________    2  _________________///
                      TextFormField(
                        initialValue: initValues['price'],
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.parse(val) == null) {
                            return 'Please enter invalid number';
                          }
                          if (double.parse(val) <= 0) {
                            return 'Please enter a number greaater than 0.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          labelText: 'Price',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                        focusNode: _pricefoucsnode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descrpfoucs);
                        },
                        onSaved: (value) {
                          _newitem = Product(
                              title: _newitem.title,
                              id: _newitem.id,
                              isFav: _newitem.isFav,
                              description: _newitem.description,
                              price: double.parse(value),
                              imageUrl: _newitem.imageUrl);
                        },
                      ),
                      SizedBox(
                        height: 11.0,
                      ),

                      //  ___________________    3   _________________///
                      TextFormField(
                        initialValue: initValues['desc'],
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter a discription.';
                          }
                          if (val.length < 10) {
                            return 'Should be at least 10 characters long.';
                          }
                          return null;
                        },
                        focusNode: _descrpfoucs,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          _newitem = Product(
                              title: _newitem.title,
                              id: _newitem.id,
                              isFav: _newitem.isFav,
                              description: value,
                              price: _newitem.price,
                              imageUrl: _newitem.imageUrl);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 8, right: 10),
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imagctrl.text.isEmpty
                                ? Text('Enter an URL')
                                : FittedBox(
                                    child: Image.network(_imagctrl.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            //  ___________________    4   _________________///
                            child: TextFormField(
                              validator: (val) {
                                if (val.isEmpty) {
                                  updateimg();
                                  return 'Please enter an URL';
                                }
                                if (!val.startsWith('http') &&
                                    !val.startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                if (!val.endsWith('.png') &&
                                    !val.endsWith('.jpg') &&
                                    !val.endsWith('.jpeg')) {
                                  return 'Please enter a valid URL';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                labelText: 'Image URL',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imagctrl,
                              focusNode: _imagfocus,
                              onSaved: (value) {
                                _newitem = Product(
                                    title: _newitem.title,
                                    id: _newitem.id,
                                    isFav: _newitem.isFav,
                                    description: _newitem.description,
                                    price: _newitem.price,
                                    imageUrl: value);
                              },
                              onFieldSubmitted: (_) {
                                _saveform();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
