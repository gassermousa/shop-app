import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../models/http_exp.dart';
import 'dart:async';
//import 'package:shared_preferences/shared_preferences.dart';;
class Auth with ChangeNotifier {
  String _token;
  DateTime _expirydate;
  String _userID;
  Timer _authtimer;
  
  
  
  String get token {
    if (_expirydate != null &&
        _expirydate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get isauth {
    return token != null;
  }
  String get userID{
    return _userID;
  }

 

  Future<void> selectURL(String email, String pass, String segurl) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$segurl?key=AIzaSyC5dqz-5kE0vxo5E90vV-8aiYTl51eciXg';
      final res = await post(url,
          body: json.encode(
              {'email': email, 'password': pass, 'returnSecureToken': true}));
      print(json.decode(res.body));
      final resdata = json.decode(res.body);
      if (resdata['error'] != null) {
        throw Httpexp(resdata['error']['message']);
      }
      _token = resdata['idToken'];
      _userID = resdata['localId'];
      _expirydate = DateTime.now()
          .add(Duration(seconds: int.parse(resdata['expiresIn'])));
      autologout();
      notifyListeners();
     /* final prefs=await SharedPreferences.getInstance();
      final userData=json.encode({
        'token':_token,
        'userID':_userID,
        'expirydate':_expirydate.toIso8601String(),
      });
      prefs.setString('userData', userData);*/

    } catch (e) {
      throw e;
    }
  }

  Future<void> singup(String email, String pass) async {
    return await selectURL(email, pass, 'signUp');
  }

  Future<void> singin(String email, String pass) async {
    return await selectURL(email, pass, 'signInWithPassword');
  }

 /* Future<bool> autologin()async{
    final prefs=await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractdata=json.decode(prefs.getString('userData')) as Map<String,Object>;
    final expirydate=DateTime.parse(extractdata['expirydate']);

    if(expirydate.isBefore(DateTime.now())){
      return false;
    }
    _token=extractdata['token'];
    _userID=extractdata['userID'];
    _expirydate=expirydate;
    notifyListeners();
    autologout();
    return true;

  }*/

  void logout(){
    _token=null;
    _userID=null;
    _expirydate=null;
    if(_authtimer!=null){
      _authtimer.cancel();
      _authtimer=null;     
    }
    notifyListeners();
  }

  void autologout(){
    if(_authtimer!=null){
      _authtimer.cancel();     
    }
    final timetoexpiry=_expirydate.difference(DateTime.now()).inSeconds;
    _authtimer=Timer(Duration(seconds: timetoexpiry),logout);

  }
}
