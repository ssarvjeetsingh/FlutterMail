
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailingsystem/providers/auth_provider.dart';
import 'package:mailingsystem/providers/mails.dart';
import 'package:mailingsystem/screens/MailScreen.dart';
import 'package:provider/provider.dart';

class AfterLogin extends StatelessWidget{

  final type;
  AfterLogin(this.type);
  @override
  Widget build(BuildContext context) {

    final mails=Provider.of<Mail>(context,listen: false);

    // TODO: implement build
    return Dismissible(
        key: ValueKey(mails.id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(Icons.delete,color: Colors.white,size: 40,),
          alignment: Alignment.centerRight,
          //padding: EdgeInsets.only(right: 20),
          //margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4) ,
        ),
        direction: DismissDirection.endToStart, //sets the direction of dissmiss
        confirmDismiss:(direction) {
          return showDialog(context: context,
              builder: (ctx) =>
                  AlertDialog(
                    title: Text("Are you Sure?"),
                    content: Text("Do youu want to remove this item from cart"),
                    actions: <Widget>[
                      FlatButton(onPressed: () {
                        Navigator.of(context).pop(false);
                      }, child: Text("No", style: TextStyle(color: Theme
                          .of(context)
                          .accentColor),)),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          }, child: Text("Yes", style: TextStyle(color: Theme
                          .of(context)
                          .accentColor)))
                    ],
                  )
          );
        },
        onDismissed: (direction){
          Provider.of<MailsDetails>(context,listen: false).deleteMail(mails.id);
        },

        child: Card( //child of dissmiss
          elevation: 5,
          child:ListTile(
            leading: CircleAvatar(
              child: Text(getText(mails)),
            ),
            title: Text(type=="Inbox"||type==null||type=="Important"?mails.from:mails.to),
            subtitle: Text(mails.subject),
            trailing:Container(
              width: 180,
              child:Row(children: <Widget>[
                Text(DateFormat("dd/MM/yyyy hh:mm").format(mails.date)),
                SizedBox(
                  width: 0,
                ),
                Expanded(
                    child:Consumer<Mail>(builder: (ctx,product,child)=>
                        IconButton(icon: Icon(product.isFavrite?Icons.star:Icons.star_border,color: Colors.red,),
                            onPressed: (){
                    try{
                    mails.getingfavorite(Provider.of<AuthProvider>(context,listen: false).mailId,Provider.of<AuthProvider>(context,listen: false).token);
                    //scaffold.showSnackBar(SnackBar(content: Text("${status} ",textAlign: TextAlign.center,)),);
                    }catch(error){
                    print("sorry");
                    // scaffold.showSnackBar(SnackBar(content: Text("${error} ",textAlign: TextAlign.center,)),);
                    }

                    }

                        ),

                )
                ),
                getSatus(mails,context)

              ] ,
              ),
            ) ,
            onTap: (){
              Navigator.of(context).pushNamed(MailScreen.routeName,arguments:mails);
            },
          ) ,
        ));
  }

  String getText(Mail mail)
  {

    if(type=="Inbox"||type==null||type=="Important")
      {
       return mail.from.substring(0,1).toUpperCase();
      }
    else if(type=="Sent"){
      return mail.to.substring(0,1).toUpperCase();
    }
    else
      if(type=="Important"){
       return "H";
      }

    return null;

  }

  Widget getSatus(Mail mail,BuildContext context)
  {
    if(mail.to==Provider.of<AuthProvider>(context).mailId)
      {
        return Icon(Icons.call_received,color: Colors.red,);
      }
    else{
      return Icon(Icons.call_made,color: Colors.red,);
    }

  }



}