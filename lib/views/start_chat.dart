import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/utils/reusable_widgets.dart';
import 'package:messenger/utils/util.dart';
import 'package:messenger/views/chatroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:messenger/views/search_users_delegator.dart';

class StartChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              uiTitle(height, 'Select contact'),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isNotEqualTo: Util.myData['email'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      height: height(context) * 0.7,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }

                  if (snapshot.data.docs.length == 0) {
                    return Container(
                      height: height(context) * 0.7,
                      child: Center(
                        child: Text('No contacts available'),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      User user =
                          User.fromJson(snapshot.data.docs[index].data());
                      user.id = snapshot.data.docs[index].id;
                      return InkWell(
                        onTap: () async {
                          Get.to(() => ChatRoom(user),
                              transition: Transition.topLevel,
                              duration: Duration(milliseconds: 500));
                        },
                        child: contactCard(user),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  appBar(context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: TextColor),
      actions: [
        appbarActions(context),
      ],
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
}
