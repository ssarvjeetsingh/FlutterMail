
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailingsystem/providers/auth_provider.dart';
import 'package:mailingsystem/providers/mails.dart';
import 'package:mailingsystem/side_drawer.dart';
import 'package:mailingsystem/widgets/AfterLogin.dart';
import 'package:provider/provider.dart';
import 'MailScreen.dart';

class AfterLoginScreen extends StatefulWidget{
  static const routeName="/AfterLogin";

  final sidebartitle;
  AfterLoginScreen(this.sidebartitle);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AfterLoginScreenState();
  }

}


class AfterLoginScreenState extends State<AfterLoginScreen> {
  var isLoading=false;


  @override
  void initState() {
    // TODO: implement initState
   isLoading=true;
    Future.delayed(Duration.zero).then((_)async{
try {
  await Provider.of<MailsDetails>(context, listen: false).fetchMails();

  setState(() {
    isLoading = false;
  });
}catch(error){


    isLoading = false;
}
    });

  }

  @override
  Widget build(BuildContext context) {
    List<Mail> mails=[];

    final _argument= ModalRoute.of(context).settings.arguments as String;
    if (_argument=="Inbox"||_argument==null) {
      if(_argument==null){
        mails=[];
      }
      mails= Provider.of<MailsDetails>(context,listen: false).getInbox();
    }
    else if (_argument=="Sent"&&_argument!=null) {
      mails = Provider.of<MailsDetails>(context,listen: false).getOutBox();
       }
    else if (_argument=="Important"&&_argument!=null) {
      mails = Provider.of<MailsDetails>(context,listen: false).onlyFav;
    }
print("hello build");
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(_argument==null?"Inbox":_argument),
      ),
      drawer:  SideDrawer(widget.sidebartitle==null?"":widget.sidebartitle),
      body:isLoading?Center(
    child:CircularProgressIndicator()
    ):mails==null||mails.isEmpty?Center(child: Text("no mails yet"),):ListView.builder(

    itemCount: mails.length,
    itemBuilder: (ctx,index){
    print(mails[index].to);
    return ChangeNotifierProvider.value(
      value: mails[index],
      child:AfterLogin(_argument) ,
    );
    })
       , floatingActionButton:FloatingActionButton(onPressed: (){
        Navigator.of(context).pushNamed(
            MailScreen.routeName,
        );
      },child: Icon(Icons.add)
    )
    );
  }


}