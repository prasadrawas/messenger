import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messenger/models/user.dart';
import 'package:messenger/utils/reusable_widgets.dart';
import 'package:messenger/views/chatroom.dart';

class SearchUsers extends SearchDelegate<User> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          query = '';
          Get.back();
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: searchNames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        if (!snapshot.hasData) {
          return Container(
            height: 150,
            child: Center(
                child:
                    Text('Search your contacts', textAlign: TextAlign.center)),
          );
        }
        if (snapshot.data.length == 0) {
          return Container(
            height: 150,
            child: Center(
                child: Text('No results found', textAlign: TextAlign.center)),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.off(() => ChatRoom(snapshot.data[index]));
                },
                child: contactCard(snapshot.data[index]),
              );
            }); 
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      height: 150,
      child: Center(
          child: Text('Search your contacts', textAlign: TextAlign.center)),
    );
  }

  Future<List<User>> indexSearching() async {
    List<User> list = [];
    try {
      await _firestore
          .collection('users')
          .where('index', isEqualTo: query[0].toLowerCase())
          .get()
          .then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          list.add(User.fromJson(value.docs[0].data()));
        }
      });
    } catch (e) {
      snackBar('Failed to search', e.code.toString());
    }
    return list;
  }

  Future<List<User>> searchNames() async {
    var indexSearches = await indexSearching();
    List<User> names = [];
    for (int i = 0; i < indexSearches.length; i++) {
      if (indexSearches[i].name.toLowerCase().contains(query)) {
        names.add(indexSearches[i]);
      }
    }
    print(names);
    return names;
  }
}
