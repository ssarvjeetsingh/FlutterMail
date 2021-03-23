
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailingsystem/providers/accounts.dart';
import 'package:mailingsystem/providers/auth_provider.dart';
import 'package:mailingsystem/providers/mails.dart';
import 'package:mailingsystem/screens/AfterLoginScreen.dart';
import 'package:mailingsystem/screens/MailScreen.dart';
import 'package:mailingsystem/screens/loginScreen1.dart';
import 'package:mailingsystem/screens/login_screen.dart';
import 'package:mailingsystem/screens/signup_screen.dart';
import 'package:mailingsystem/screens/splashscreen.dart';
import 'package:provider/provider.dart';


void main(){

  runApp(MyApp());

}


class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [

      ChangeNotifierProvider(
        create: (ctx) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => AccountInfo(),
      ),
      ChangeNotifierProxyProvider<AuthProvider,MailsDetails>(
        update: (ctx,auth,previousMails)=>MailsDetails(auth.token,previousMails==null?[]:previousMails.mail,auth.mailId,auth.userId),

      ),

    ],
        child: Consumer<AuthProvider>(builder: (ctx,auth,child)=>MaterialApp(
           debugShowCheckedModeBanner: false,
          title: "Let's Mail",
          home: auth.Authenticity?AfterLoginScreen(auth.mailId):FutureBuilder(future:auth.autoLogin(),
              builder: (ctx,snapshotData)=>snapshotData.connectionState==ConnectionState.waiting?SplashScreen():Login1()),
          theme: ThemeData(
              primarySwatch: Colors.red
          ),


          routes: {
            LoginScreeen.routeName:(cts)=>LoginScreeen(),
            SignUpScreen.routeName: (ctx) => SignUpScreen(),
            MailScreen.routeName:(ctx)=>MailScreen(),
            AfterLoginScreen.routeName:(ctx)=>AfterLoginScreen(auth.mailId)
          },

        )
        )

    );
    // TODO: implement build
  }
}