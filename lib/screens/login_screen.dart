
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailingsystem/providers/accounts.dart';
import 'package:mailingsystem/screens/AfterLoginScreen.dart';
import 'package:mailingsystem/side_drawer.dart';

import 'package:mailingsystem/widgets/Login.dart';
import 'package:provider/provider.dart';

/*class LoginScreeen extends StatefulWidget
{


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreeenState();
  }
}*/

class LoginScreeen extends StatelessWidget
{
  static const routeName="LoginScreen";
  var isLogin=false;
  String  mail=null;
  @override

  void onLogin(BuildContext context,String mailcontrol,String passcontrol)
  {
    isLogin=Provider.of<AccountInfo>(context,listen: false).onSignIn(mailcontrol,passcontrol);

    if(isLogin)
      {
        mail=mailcontrol;
        Provider.of<AccountInfo>(context,listen: false).setName(mailcontrol);
        Navigator.of(context).pushReplacementNamed(
            AfterLoginScreen.routeName,
            arguments:[mail,"Inbox"]);
      }

    }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

        appBar: AppBar(
          title: Text("Let's Mail"),
        ),
        // drawer: SideDrawer(),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 12,horizontal: 20),

          child: Login(onLogin)

          //AfterLogin(mail,"login")

          ),
      /*floatingActionButton:isLogin?FloatingActionButton(onPressed: (){
        Navigator.of(context).pushNamed(
          MailScreen.routeName,
          arguments: mail
        ) ;
      },child: Icon(Icons.add)
      ):null*/
    );
  }

}