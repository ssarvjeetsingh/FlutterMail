
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:mailingsystem/Http_Execption/HttpException.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider with ChangeNotifier{

  String _Token;
  DateTime _ExpireDate;
  String _UserName;
  String _userMail;
  Timer authTime;

  bool get Authenticity{
    return _Token!=null;
  }

  String get mailId{
    if(_ExpireDate!=null&&_Token!=null&&_ExpireDate.isAfter(DateTime.now())){
      return _userMail;
    }
  }
  String get token{
    if(_ExpireDate!=null&&_Token!=null&&_ExpireDate.isAfter(DateTime.now())){
      return _Token;
    }
    return  null;
  }

  String get userId{
    if(_ExpireDate!=null&&_Token!=null&&_ExpireDate.isAfter(DateTime.now())){
      return _UserName;
    }
    return  null;
  }

  Future<void> loginAndSignup (email,password,urlSegment) async
  {
    final url="https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBBqwZu1aXTv27TECPw65NjymhlBFNeOug";
    try{
      final response= await http.post(url,body: jsonEncode({
        "email":email,
        "password":password,
        'returnSecureToken':true
      }));

      final responseData=jsonDecode(response.body);

      if(responseData["error"]!=null){

        throw HttpException(responseData["error"]["message"]);
      }

      _Token=responseData["idToken"];
      _ExpireDate=DateTime.now().add(Duration(seconds:int.parse(responseData['expiresIn'])));
      _UserName=responseData["localId"];
      _userMail=responseData['email'];

      notifyListeners();
      final pref= await SharedPreferences.getInstance();
      final userData=json.encode({"token":_Token,"expireDate":_ExpireDate.toIso8601String(),"userId":_UserName,"usermail":_userMail});
      pref.setString("userdata", userData);

    }
    catch(error){
      print(error);
      throw(error);
    }
  }

  Future<void> login(email,password)async{
   return  loginAndSignup(email, password, "signInWithPassword");
  }

  Future<void> signUp(email,password)async{

    return loginAndSignup(email, password, "signUp");
  }




  Future<void> logOut()async{
    _Token=null;
    _ExpireDate=null;
    _UserName=null;
    _userMail=null;
    if(authTime!=null){
      authTime.cancel();
      authTime=null;
    }
    notifyListeners();
    final pref=await SharedPreferences.getInstance();
    pref.clear();

  }



 Future<bool> autoLogin() async
   {
     final pref=await SharedPreferences.getInstance();

     if(!pref.containsKey("userdata")){
       return false;
     }
     final extraxtedData=jsonDecode(pref.get("userdata"))as Map<String,dynamic>;
     final expireDate=DateTime.parse(extraxtedData["expireDate"]);


     if(expireDate.isBefore(DateTime.now()))
     {
       return false;
     }

     _Token=extraxtedData["token"];
     _ExpireDate=expireDate;
     _UserName=extraxtedData["userId"];
     _userMail=extraxtedData["usermail"];
     notifyListeners();
     _autoLogOut();
     return true;

   }

  void _autoLogOut(){
    if(authTime!=null)
    {
      authTime.cancel();
    }
    final expireTiming=_ExpireDate.difference(DateTime.now()).inSeconds;
    print(expireTiming);
    authTime=Timer(Duration(seconds: expireTiming), logOut);

  }

/*  Future<bool> checkSender(String mail)async
  {
    final url="https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBBqwZu1aXTv27TECPw65NjymhlBFNeOug";
    final response=await http.post(url,body:
      null
    );

    final responseData=json.decode(response.body);
    if(responseData["error"]==null)
      {
        return false;
      }
    return true;


  }*/

}