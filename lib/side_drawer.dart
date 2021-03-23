


import 'package:flutter/material.dart';
import 'package:mailingsystem/screens/AfterLoginScreen.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';

class SideDrawer extends StatelessWidget
{

  final title;

  const SideDrawer( this.title);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(child:Column(
      children: <Widget>[
        AppBar(title: Text(title),
        ),
        Divider(),
       getList(context)
      ],
    ) ,);
  }
  Widget getList(BuildContext context)
  {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.inbox,color: Theme.of(context).accentColor,),
          title: Text("Inbox"),
          onTap: (){
            Navigator.of(context).pushReplacementNamed(AfterLoginScreen.routeName,
                arguments:"Inbox"
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.send,color: Theme.of(context).accentColor),
          title: Text("Sent"),
          onTap: (){
              //AfterLogin(isLogin, "sent");
            Navigator.of(context).pushReplacementNamed(AfterLoginScreen.routeName,
                arguments:"Sent"
            );
          },

        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.star,color: Theme.of(context).accentColor),
          title: Text("Important"),
          onTap: (){
            Navigator.of(context).pushReplacementNamed(AfterLoginScreen.routeName,
                arguments:"Important"
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.person_outline,color: Theme.of(context).accentColor),
          title: Text("Logout"),
          onTap: (){
             Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed("/");
            Provider.of<AuthProvider>(context,listen: false).logOut();
          },

        ),

      ],
    );
  }





}