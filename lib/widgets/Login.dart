

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailingsystem/screens/signup_screen.dart';

class Login extends StatelessWidget{
  final formkey=GlobalKey<FormState>();
  final mailcontrol=TextEditingController();
  final passcontrol=TextEditingController();

  final mailfocus=FocusNode();
  final passfocus=FocusNode();

  final Function login;

   Login(this.login);


   void onLogin(BuildContext context)
   {
     if(formkey.currentState.validate()){
       login(context,mailcontrol.text,passcontrol.text);
     //  setShare();
     }


   }

  /*void setShare()async
  {
    final pref= await SharedPreferences.getInstance();
    pref.setString("mailid",mailcontrol.text );

  }*/


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
        key: formkey,
        child: ListView(children: <Widget>[
          Container(
            height:120,
            width:120,
            child:Image(image:AssetImage("images/mail.png"),),
          ),
          TextFormField(
            controller: mailcontrol,
            keyboardType: TextInputType.emailAddress,
            focusNode: mailfocus,
            decoration: InputDecoration(
              labelText: "Enter mail id",
            ),
            validator: (value){
              if(value.isEmpty)
              {
                return "please fil this ";
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_){
              FocusScope.of(context).requestFocus(passfocus);
            },
          ),
          TextFormField(
            controller: passcontrol,
            focusNode: passfocus,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: "Password",
            ),
            validator: (value){
              if(value.isEmpty)
              {
                return "please fil this ";
              }
              return null;

            },
          ),
          SizedBox(
            height: 12,
          ),
          FlatButton(color:Colors.red ,onPressed: (){
            onLogin(context);
          }, child:Text("Login"),),

              FlatButton(onPressed: (){ Navigator.of(context).pushNamed(
                  SignUpScreen.routeName
              );
              },
                  child:Text("create new account!",style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.bold),)
              ),




        ],
        )

    );
  }

}