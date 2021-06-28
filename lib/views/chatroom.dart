import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/utils/chatOperations.dart';
import 'package:messenger/utils/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/utils/util.dart';
import 'package:messenger/views/view_profile.dart';

class ChatRoom extends StatelessWidget {
  final User user;
  bool firstMsg = false;
  ChatOperations chat = ChatOperations();
  final _messageController = TextEditingController();
  ChatRoom(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          if (orientation(context) == Orientation.portrait) {
            return Stack(
              children: [
                portraitView(height(context)),
                messageBox(height(context)),
              ],
            );
          } else {
            return Stack(
              children: [
                portraitView(width(context)),
                messageBox(width(context)),
              ],
            );
          }
        }),
      ),
      // bottomNavigationBar: messageBox(height),
    );
  }

  portraitView(size) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 50),
      child: StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child(Util.myData['id'])
            .child('chats')
            .child(user.id)
            .onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }

          if (snapshot.data.snapshot.value == null) {
            firstMsg = true;
            return Container(
              height: size,
              child: Center(
                child: TextButton(
                    onPressed: () {
                      chat.createEntry(Util.myData['id'], user);
                    },
                    child: Text(
                      'Send Hello !',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
            );
          }

          var map = snapshot.data.snapshot.value;
          var keys = map.keys;
          return ListView.builder(
            itemCount: map.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              var msg = map[keys.elementAt(index)];
              if (msg['sentFrom'] == 0) {
                return sendersMessage(msg['messege'], msg['time']);
              } else {
                return reciversMessage(msg['messege'], msg['time']);
              }
            },
          );
        },
      ),
    );
  }

  messageBox(height) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: height * 0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 5,
              child: MessageTextField(height, _messageController),
            ),
            Flexible(
              flex: 1,
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.blueAccent,
                  size: 25,
                ),
                onPressed: () {
                  String msg = _messageController.text.trim();
                  if (msg.isNotEmpty) {
                    if (firstMsg) {
                      chat.createEntry(Util.myData['id'], user, msg: msg);
                    } else {
                      chat.sendMessege(msg,
                          Util.myData['id'], user.id);
                    }
                  }
                  _messageController.clear();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: InkWell(
        onTap: () {
          Get.to(() => ViewProfile(user),
              transition: Transition.topLevel,
              duration: Duration(milliseconds: 500));
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              user.image == ""
                  ? CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage('assets/images/uploadImg_cover.png'),
                    )
                  : CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(user.image),
                    ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: TextColor, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
            icon: Icon(
              FontAwesomeIcons.ellipsisV,
              size: 16,
            ),
            onPressed: () {})
      ],
      elevation: 2,
      iconTheme: IconThemeData(color: Color(0xFF424242)),
    );
  }
}
