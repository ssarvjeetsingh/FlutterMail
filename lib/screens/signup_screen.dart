import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accounts.dart';

class SignUpScreen extends StatefulWidget {
  @override
  static const routeName="/signupscreen";
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignUpScreenstate();
  }
}
class SignUpScreenstate extends State<SignUpScreen>{


  final contactfocus=FocusNode();
  final mailfocus=FocusNode();
  final passwordfocus=FocusNode();
  final conpasswordfocus=FocusNode();
  final formkey=GlobalKey<FormState>();
  final conpasscontrole=TextEditingController();
  final passwordcontrole=TextEditingController();
  var accounts =Accounts(id:'',name: '',contact: '',password: '',mail: '');


  AccountInfo accountInfo;
  @override
  void initState() {
    // TODO: implement initState
    accountInfo=Provider.of<AccountInfo>(context,listen: false);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    contactfocus.dispose();
    passwordfocus.dispose();
    mailfocus.dispose();

    super.dispose();
  }


  void onSave(){

    final isvalidate=formkey.currentState.validate();

    if(isvalidate)
      {
        formkey.currentState.save();
        accountInfo.addAcoount(accounts);
        Navigator.of(context).pop();
      }


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Signup"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed:()
          {
            onSave();
          }
          )
        ],
      ),

      body:
          Form(
              key: formkey,
              child:ListView(
            children: <Widget>[
              TextFormField(

                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Name",

                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted:(value){
                  FocusScope.of(context).requestFocus(contactfocus);
                },

                validator: (value){
                  if(value.isEmpty){
                    return "please enter this field";
                  }
                  return null;
                },
                onSaved:(value){

                       accounts=Accounts(
                         id: accounts.id,
                         name: value,
                         mail: accounts.mail,
                         contact: accounts.contact,
                         password: accounts.password
                       );
                },
              ),
              TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: contactfocus,
                  decoration: InputDecoration(
                    labelText: "Contact no.",

                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted:(value){
                    FocusScope.of(context).requestFocus(mailfocus);
                  },

                  validator: (value){
          if(value.isEmpty){
          return "please enter this field";
          }
          return null;
          },
              onSaved:(value){

                accounts=Accounts(
                    id: accounts.id,
                    name: accounts.name,
                    mail: accounts.mail,
                    contact:value,
                    password: accounts.password
                );
              }
              ),
              TextFormField(

                  focusNode: mailfocus,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Set Mail id",

                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted:(value){
                    FocusScope.of(context).requestFocus(passwordfocus);
                  },
                  validator: (value){
          if(value.isEmpty){
          return "please enter this field";
          }
          return null;
          },
              onSaved:(value){

                accounts=Accounts(
                    id: accounts.id,
                    name: accounts.name,
                    mail: value,
                    contact: accounts.contact,
                    password: accounts.password
                );
              }
              ),
              TextFormField(
                  controller: passwordcontrole,
                  focusNode: passwordfocus,
                  decoration: InputDecoration(
                    labelText: "Password",

                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted:(value){
                    FocusScope.of(context).requestFocus(conpasswordfocus);
                  },
                  validator: (value){
          if(value.isEmpty){
          return "please enter this field";
          }
          else
            if(value.length<5){
            return "password must contains at least 10 words";
          }
          return null;
          },
              onSaved:(value){

                accounts=Accounts(
                    id: accounts.id,
                    name: accounts.name,
                    mail: accounts.mail,
                    contact: accounts.contact,
                    password: value
                );
              }
              ),
              TextFormField(
                controller: conpasscontrole,
                textInputAction: TextInputAction.done,
                focusNode: conpasswordfocus,
                decoration: InputDecoration(
                  labelText: "Confirm Password",

                ),
                  validator: (value){

                    if(value.isEmpty){
                      return "please enter this field";
                    }
                    else
                      if(conpasscontrole.text!=passwordcontrole.text){
                        return "enter right pass";
                    }

                    return null;
                  },
                  onSaved:(value){

                    accounts=Accounts(
                        id: DateTime.now().toString(),
                        name: accounts.name,
                        mail: accounts.mail,
                        contact: accounts.contact,
                        password: accounts.password
                    );
                  },
                onFieldSubmitted: (_){
                  onSave();
                },

              ),


            ],
          )
          )


    );
  }

}