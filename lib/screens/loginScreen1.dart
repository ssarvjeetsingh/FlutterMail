import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailingsystem/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:mailingsystem/Http_Execption/HttpException.dart';

enum AuthMode { Signup, Login }

class Login1 extends StatelessWidget {
  static const routeName="/";
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("welcome"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                Color.fromRGBO(240, 188, 117, 1).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            )),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-5 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black38,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'Let\'s Mail!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: LoginContent(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LoginContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginContentState();
  }
}

class LoginContentState extends State<LoginContent> {
  AuthMode userMode = AuthMode.Login;


  var isLoading=false;
  GlobalKey<FormState> _formKey=GlobalKey();
final _passwordController=TextEditingController();
  Map<String, String> userData = {"email": "", "password": ""};

  void _switchAccount() {
    if (userMode == AuthMode.Login) {
      setState(() {
        userMode = AuthMode.Signup;
      });
    } else if (userMode == AuthMode.Signup) {
      setState(() {
        userMode=AuthMode.Login;
      });
    }
  }
  void showErrorDialog(String message){

    showDialog(context:context,builder: (ctx)=>AlertDialog(
      title:Text("Something Wrong"),
      content:Text(message),
      actions: <Widget>[
        FlatButton(onPressed: (){

          setState(() {
            isLoading=false;
            Navigator.of(context).pop();
          });
        },
            child: Text("Ok",style: TextStyle(color: Theme.of(context).accentColor),)
        )
      ]
      ,)

    );
  }

  void _onSubmit ()async
  {
    final validate=_formKey.currentState.validate();
    if(!validate)
      {
        return;
      }
    setState(() {
      isLoading=true;
    });
    _formKey.currentState.save();
    try {

      if(userMode==AuthMode.Login)
        {
          await Provider.of<AuthProvider>(context, listen: false).login(
              userData["email"].toLowerCase().trim(), userData["password"]);
        }
      else
        if(userMode==AuthMode.Signup)
        {
          await Provider.of<AuthProvider>(context, listen: false).signUp(
              userData["email"].toLowerCase().trim(), userData["password"]);
        }

    }on HttpException catch(error){
      print("heelo2");

      var errormessage="Could not Authenticat you";

      if(error.tooString().contains("EMAIL_EXISTS"))
      {
        errormessage="this mail already exits";
      }
      else if(error.tooString().contains("INVALID_EMAIL")){
        errormessage="This mail not valid";
      }
      else if(error.tooString().contains("WEAK_PASSWORD")){
        errormessage="Password is too weak";
      }
      else if(error.tooString().contains("INVALID_PASSWORD")){
        errormessage="Invalid Password";
      }
      else if(error.tooString().contains("EMAIL_NOT_FOUND")){
        errormessage="can not found this Email";
      }
      showErrorDialog(errormessage);
    }
    catch(error){
      var errorMessage="Sorry Please try again later!";
      showErrorDialog(errorMessage);
    }


  }
  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Container(
          height: 320,
          width: deviceSize.width * 0.75,
          constraints: BoxConstraints(
            minHeight: 320,
          ),
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      else
                        if(value.substring(value.length-4,value.length)!=".com"){
                        return "mail Id must contain .com at last";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userData['email'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userData['password'] = value;
                    },
                  ),

                 if(userMode==AuthMode.Signup)
                   TextFormField(
                     enabled: userMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: userMode == AuthMode.Signup
                ? (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match!';
              }

            }
                :  null,

                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //if (_isLoading)
                  //CircularProgressIndicator()
                  //else
                  RaisedButton(
                    child:isLoading?CircularProgressIndicator(backgroundColor: Colors.white,): Text(userMode==AuthMode.Login?"Login":"SignUp"),
                    onPressed:_onSubmit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                  ),
                  FlatButton(
                    child: Text(userMode==AuthMode.Login?"don't have account":"Alredy have Account"),
                    onPressed:
                    _switchAccount,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).accentColor,
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
