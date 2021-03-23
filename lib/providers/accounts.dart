

import 'package:flutter/cupertino.dart';

class Accounts {

  final String id;
  final String name;
  final String contact;
  final String mail;
  final String password;

  Accounts({this.id, this.name, this.contact, this.mail, this.password});
}

class AccountInfo with ChangeNotifier{

  List<Accounts> accounts = [];
   var Name;

  void addAcoount(Accounts newaccount) {

  var isExits=false;
    accounts.forEach((acct){

      if(acct.mail==newaccount.mail){
        isExits=true;
        print("sorry");
        return;
      }
    });


    if(!isExits){
      accounts.add(newaccount);

      print("added");

    }

  }


  bool onSignIn(String mail,String password)
  {

print("ayya");
var Exists;
try{
  Exists=accounts.firstWhere((test){
    notifyListeners();
    return test.mail==mail&&test.password==password;
  });

}catch(error){
  print("sorry error");
}

   if(Exists==null)
     {
     return false;
     }

     return true;


  }

  bool accExists(String mailid){
    var exists;
    try{
       exists=accounts.firstWhere((test){
        return test.mail==mailid;
      });
    }
    catch(error){
      print(error);
      return false;
    }


    if(exists!=null){
      return true;
    }
    print("not exits");
    return false;

  }



  void setName(String mail){
   final Exists=accounts.firstWhere((test){

     return test.mail==mail;
   });

   Name=Exists.name;
}

String get name{

    return Name;
}

}