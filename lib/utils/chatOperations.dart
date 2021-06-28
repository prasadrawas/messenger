import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/utils/util.dart';

class ChatOperations {
  final DatabaseReference db = FirebaseDatabase.instance.reference();

  void printReference() {
    print(db.child('messeges').path);
  }

  Future<void> createEntry(String myId, User user, {String msg='Hello !'}) async {
    await db.child(myId).child('friends').child(user.id).set(user.toJson());

    await db.child(user.id).child('friends').child(myId).set(Util.myData);
    sendMessege('$msg', myId, user.id);
  }

  void sendMessege(String messege, String myId, String uId) async {
    
    var time = DateFormat('hh:mm a').format(DateTime.now());
    db
        .child(myId)
        .child('chats')
        .child(uId)
        .push()
        .set({'time': time, 'messege': messege, 'sentFrom': 1});
    db
        .child(uId)
        .child('chats')
        .child(myId)
        .push()
        .set({'time': time, 'messege': messege, 'sentFrom': 0});

    db.child(myId).child('friends').child(uId).update({'lastMsg': messege});

    db.child(uId).child('friends').child(myId).update({'lastMsg': messege});
  }
}
