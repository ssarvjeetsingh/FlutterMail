
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mailingsystem/Http_Execption/HttpException.dart';
class Mail with ChangeNotifier{

  final String  id;
  final String from;
  final String to;
  final String subject;
  final String message;
  final DateTime date;
   bool isFavrite;

  Mail({this.id, this.from, this.to, this.subject, this.message, this.date,this.isFavrite=false});

  Future<void> getingfavorite (String userId,String authToken) async
  {
    print(id);
    isFavrite=!isFavrite;
    notifyListeners();
    var url="https://letstalk-20223.firebaseio.com/userImportantMails/${userId.substring(0,userId.length-4)}/$id.json?auth=$authToken";


    final response=  await http.put(url,body: json.encode(
        isFavrite
    ));

    if(response.statusCode>=400) {
      isFavrite=!isFavrite;

      notifyListeners();

      throw HttpException(!isFavrite?"Can't Add":"Can't Remove");
    }
   // return isFavrite?"Add to Favrite":"Remove from Favrite";

  }
}

class MailsDetails with ChangeNotifier{
  List<Mail> mail=[];
  final token;
  final mailId;
  final userName;
  MailsDetails(this.token,this.mail,this.mailId,this.userName);


  Future<void> fetchMails() async{
    try {
      var url = "https://letstalk-20223.firebaseio.com/mails/${mailId.toString()
          .substring(0, mailId
          .toString()
          .length - 4)}.json?$token";
      final response = await http.get(url);

      final serverData = jsonDecode(response.body) as Map<String, dynamic>;

      if (serverData == null) {
        return null;
      }
      url = "https://letstalk-20223.firebaseio.com/userImportantMails/${mailId
          .substring(0, mailId.length - 4)}.json?auth=$token";
      final favreponse = await http.get(url);
      final favData = jsonDecode(favreponse.body);


      List<Mail> mal = [];
      serverData.forEach((mid, data) {
        mal.add(Mail(
            id: mid,
            from: data["from"],
            to: data["to"],
            subject: data["subject"],
            message: data["message"],
            date: DateTime.parse(data["date"]),
            isFavrite: favData == null ? false : favData[mid] ?? false
        ));
      });

      mail = mal.reversed.toList();

      notifyListeners();
    }
    catch(error){
      print(error);
    }

  }

  void addMail(Mail newmail) async
  {
  var url="https://letstalk-20223.firebaseio.com/mails/${mailId.toString().substring(0,mailId.toString().length-4)}.json?$token";
print(mailId);
       final response =await http.post(url,body: jsonEncode({
         "from":newmail.from,
          "to":newmail.to,
           "subject":newmail.subject,
           "message":newmail.message,
           "date":DateTime.now().toIso8601String()
       }));
  url="https://letstalk-20223.firebaseio.com/mails/${newmail.to.toString().substring(0,newmail.to.toString().length-4)}.json?$token";
  await http.post(url,body: jsonEncode({
    "from":newmail.from,
    "to":newmail.to,
    "subject":newmail.subject,
    "message":newmail.message,
    "date":DateTime.now().toIso8601String()
  }));


  mail.insert(0,Mail(
          id: json.decode(response.body)["name"],
          from: newmail.from,
          to:newmail.to ,
          subject: newmail.subject==null?"no Subject":newmail.subject,
          message: newmail.message,
          date: DateTime.now()) );
      print("added mils");
notifyListeners();
  }

 List<Mail>  getInbox(){
    List<Mail> sentMails=[];
    if(mail.isEmpty){
      return null;
    }
   mail.forEach((mails){
       if(mails.to==mailId){
       sentMails.add(mails);
      }
    });
   return sentMails;
  }

  List<Mail>  getOutBox(){
    List<Mail> sentMails=[];
    if(mail.isNotEmpty) {
      mail.forEach((mails) {
        if (mails.from == mailId) {
          sentMails.add(mails);
        }
      });

      return sentMails;
    }
    return null;
  }

  List<Mail> get onlyFav{
    List<Mail> sentMails=[];

    if(mail.isNotEmpty) {
      mail.forEach((mails) {
        if (mails.isFavrite==true) {
          sentMails.add(mails);
        }
      });

      return sentMails;
    }
    return null;
  }

  Mail getByID(DateTime id){
   print(id);
   if(id==null){
     return null;
   }
    return mail.firstWhere((test){
      return test.id==id;
    });
  }
void deleteMail(String id) async{

    final url="https://letstalk-20223.firebaseio.com/mails/${mailId.toString().substring(0,mailId.toString().length-4)}/$id.json?$token";
    final mailindex=mail.indexWhere((test){
      return  test.id==id;
    });
    var deletemail=mail[mailindex];
    mail.removeAt(mailindex);

    notifyListeners();

    final response= await http.delete(url);

    if(response.statusCode>=400)
    {
      mail.insert(mailindex, deletemail);
      notifyListeners();

      throw HttpException("could not deleted");
    }
   deletemail=null;

  /*  mail[mailindex]=Mail(
        id: deletemail.id,
        from: deletemail.from,
        to:deletemail.to ,
        subject: deletemail.subject,
        message: deletemail.message,
        date: deletemail.date ,
 //      delfrom:user=="Sent"?true:false,
   //   delto: user=="Inbox"?true:false
    );*/




}




}