
import 'package:flutter/material.dart';
import 'package:mailingsystem/providers/auth_provider.dart';
import 'package:mailingsystem/providers/mails.dart';

import 'package:provider/provider.dart';

class MailScreen extends StatefulWidget
{
  static const routeName="/MailScreen";



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MailScreenState();
  }

}


class MailScreenState extends State<MailScreen>{

  final fornkey=GlobalKey<FormState>();
  final tofocus=FocusNode();
  final messagefocus=FocusNode();
  final subjectfocus=FocusNode();
  var addMails=Mail(id:null,from:'',to:'',subject:'',message:'',date: null);
  var _id;
  var mailId;
  var ffrom;
  var fromtext="";
  var initialValue={
    "from":'',
    "to":'',
    "sub":"",
    "message":""
  };
  var init=true;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tofocus.dispose();
    messagefocus.dispose();
    subjectfocus.dispose();
  }

  @override
  void didChangeDependencies() {

    if(init){
      //_id=ModalRoute.of(context).settings.arguments as DateTime;
       final ffrom=ModalRoute.of(context).settings.arguments as Mail;
        mailId=Provider.of<AuthProvider>(context,listen: false).mailId;
        print(1);
       if(ffrom!=null){
         print(2);
         initialValue={
           "from":ffrom.from.trim(),
           "to":ffrom.to.trim(),
           "sub":ffrom.subject,
           "message":ffrom.message
         };
       }
      if(_id==null){
        //setShare();
        return;
      }
      //addMails=Provider.of<MailsDetails>(context,listen: false).getByID(_id);

    }
    init=false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

 /* void setShare()async
  {
    final pref= await SharedPreferences.getInstance();
    mailid=pref.getString("mailid" );

  }*/

Future<void> showErrorDialog(String id){
  showDialog(context: context,builder: (ctx)=>AlertDialog(
      title:Text("Something Wrong"),
      content:Text("$id is not valid"),
      actions: <Widget>[
        FlatButton(onPressed: ()=>Navigator.of(context).pop(),
            child: Text("Ok",style: TextStyle(color: Theme.of(context).accentColor),)
        )
      ]
  )
  );
}

  void _onSave(BuildContext context){

      final isvalid=fornkey.currentState.validate();
      if(isvalid){
          fornkey.currentState.save();

        //  final checkSender= await Provider.of<AuthProvider>(context,listen: false).checkSender(addMails.to);
         // if(!checkSender)
           // {
             // showErrorDialog(addMails.to);

            //}
        Provider.of<MailsDetails>(context,listen: false).addMail(addMails);

          print("not exuts");
        // Scaffold.of(context).showSnackBar(SnackBar(content: Text("sent")));

          Navigator.of(context).pop();
      }
  }
  void show(){

  print(initialValue["to"].trim());
  print(mailId.trim());

  }

  @override
  Widget build(BuildContext context) {
    //final mailid=ModalRoute.of(context).settings.arguments as String;


    /// print(mailid);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Compose"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.send), onPressed:/*fromtext.trim()!=mailId?show:*/(){
            _onSave(context);
          }
          )
        ],
      ),
      body: Padding(padding:EdgeInsets.symmetric(vertical: 12,horizontal: 15) ,

      child:Form(
          key: fornkey,
          child: ListView(
            children: <Widget>[
                TextFormField(

                  initialValue: initialValue["from"]==''?mailId.toString().trim():initialValue["from"].trim() ,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText:"from" ,
                    ),
                  validator: (value){
                    if(value.isEmpty){
                      return "enter this field please";
                    }
                    //else
                    //if(!Provider.of<AccountInfo>(context,listen: false).accExists(value))
                    //{
                      //return "This account not exixts";
                    //}
                    return null;
                  },
                  onFieldSubmitted: (value){
                    fromtext=value.trim();
                    print(fromtext);
                    FocusScope.of(context).requestFocus(tofocus);
                  },
                  onSaved:(value) {
                    print(3);
                    addMails=Mail(
                      id: addMails.id,
                      from: value.trim(),
                      to: addMails.to,
                      subject: addMails.subject,
                      message: addMails.message,
                      date: addMails.date
                    );
                  },

                  ),
              /*Row(
                children: <Widget>[
                  Text("to :"),
                  SizedBox(
                    width: 12,
                  ),*/
               TextFormField(
                    initialValue: initialValue["to"],
                    decoration: InputDecoration(
                      labelText:"to" ,
                    ),
                    validator: (value)   {
                     if(value.isEmpty) {
                       return "enter this field please";
                     }
                        return null;
                       },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(subjectfocus);
                          },
                      onSaved:(value) {
                        print(4);
                            addMails=Mail(
                            id: addMails.id,
                            from: addMails.from,
                              to: value.trim(),
                            subject: addMails.subject,
                            message: addMails.message,
                           date: addMails.date
                              );
      }
                  ),
              /*
                ],
              ),
              Row(
                children: <Widget>[
                  Text("subject :"),
                  SizedBox(
                    width: 12,
                  ),*/
                  TextFormField(
                    initialValue: initialValue["sub"],
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText:"subject",
                    ),

                     onFieldSubmitted: (value) {
                       FocusScope.of(context).requestFocus(messagefocus);
                     },
                      onSaved:(value) {
                        print(5);
                        addMails=Mail(
                            id: addMails.id,
                            from: addMails.from,
                            to: addMails.to,
                            subject: value,
                            message: addMails.message,
                            date: addMails.date
                        );
                      }
                    )
              /*
                ],
              ),*/,
              Container(
                height:200 ,
                width:200 ,
                child:TextFormField(
                  initialValue: initialValue["message"],
                  focusNode: messagefocus,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: "description",
                    helperMaxLines: 50,
                    focusColor: Colors.red
                  ),
                    onSaved:(value) {
                      print(6);
                      addMails=Mail(
                          id: addMails.id,
                          from: addMails.from,
                          to: addMails.to,
                          subject: addMails.subject,
                          message: value,
                          date: addMails.date
                      );
                    }
                )
              )
            ],
          )

      ) ,
      ),
    );
  }

}