import 'package:firebase_database/firebase_database.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/utils/reusable_widgets.dart';
import 'package:messenger/utils/util.dart';
import 'package:messenger/views/auth/setting.dart';
import 'package:messenger/views/chatroom.dart';
import 'package:messenger/views/search_users_delegator.dart';
import 'package:messenger/views/start_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: LayoutBuilder(builder: (context, constraints) {
            if (orientation(context) == Orientation.portrait) {
              return portraitView(height(context));
            } else {
              return landscapeView(width(context));
            }
          }),
        ),
      ),
      floatingActionButton: floatingActionButton(),
    );
  }

  Column landscapeView(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            widthFactor: 0.3,
            child: Column(
              children: [
                Image.asset('assets/images/chats_cover.png'),
                Text(
                  'No chats yet',
                  style: TextStyle(color: TextColor),
                ),
                startChatButton(height),
              ],
            ),
          ),
        )
      ],
    );
  }

  portraitView(double height) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(Util.myData['id'])
          .child('friends')
          .onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return noChatsYet(height);
        }
        if (snapshot.data.snapshot.value == 0 ||
            snapshot.data.snapshot.value == null) {
          return noChatsYet(height);
        } else {
          var map = snapshot.data.snapshot.value;
          var keys = map.keys;

          return ListView.builder(
            itemCount: map.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var data = map[keys.elementAt(index)];
              User user = User(
                  id: data['id'],
                  name: data['name'],
                  email: data['email'],
                  image: data['image'],
                  status: data['status']);
              return InkWell(
                onTap: () {
                  Get.to(() => ChatRoom(user),
                      transition: Transition.topLevel,
                      duration: Duration(milliseconds: 500));
                },
                child: contactCard(user, sub: data['lastMsg']),
              );
            },
          );
        }
      },
    );
  }

  noChatsYet(height) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.2),
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: Column(
          children: [
            Image.asset('assets/images/chats_cover.png'),
            Text(
              'No chats yet',
              style: TextStyle(color: TextColor),
            ),
            startChatButton(height),
          ],
        ),
      ),
    );
  }

  floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Get.to(() => StartChat(),
            transition: Transition.topLevel,
            duration: Duration(milliseconds: 500));
      },
      child: Icon(Icons.chat),
    );
  }

  startChatButton(height) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        height: height * 0.050,
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            onPressed: () {
              Get.to(() => StartChat(),
                  transition: Transition.topLevel,
                  duration: Duration(milliseconds: 500));
            },
            child: Text(
              'Start chat',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: height * 0.0180,
              ),
            ),
          ),
        ),
      ),
    );
  }

  appBar(context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: leadingIcon(),
      title: appbarTitle(),
      iconTheme: IconThemeData(color: TextColor),
      actions: [
        appbarActions(context),
      ],
    );
  }

  leadingIcon() {
    return Container(
      height: 10,
      width: 10,
      padding: EdgeInsets.all(10),
      child: ClipRRect(
  
          borderRadius: BorderRadius.circular(80),
          child: InkWell(
              borderRadius: BorderRadius.circular(80),
              onTap: () {
                Get.to(() => Setting(),
                    transition: Transition.topLevel,
                    duration: Duration(milliseconds: 500));
              },
              child: Util.myData['image'] == ""
                  ? Image.asset('assets/images/uploadImg_cover.png')
                  : Image.network(Util.myData['image']))),
    );
  }

  appbarActions(context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: IconButton(
        onPressed: () {
          showSearch(context: context, delegate: SearchUsers());
        },
        icon: Icon(
          Icons.search,
          color: TextColor,
        ),
      ),
    );
  }

  appbarTitle() {
    return Center(
      child: Text(
        'Messeges',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: TextColor, fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }
}
