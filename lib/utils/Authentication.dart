import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messenger/utils/util.dart';
import 'package:messenger/views/auth/app_intro.dart';

class Authentication {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  updateStatus(String email, String status) async {
    try {
      await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        value.docs[0].reference.update({'status': status});
      });
      return '200';
    } catch (e) {
      return e.code.toString();
    }
  }

  updateName(String email, String name) async {
    try {
      await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        value.docs[0].reference.update({'name': name});
      });
      return '200';
    } catch (e) {
      return e.code.toString();
    }
  }

  updateEmail(String email, String password, String newEmail) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      credential.user.updateEmail(newEmail);
      await Util.updatePref(newEmail);
      await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        value.docs[0].reference.update({'email': newEmail});
      });

      return '200';
    } catch (e) {
      return e.code.toString();
    }
  }

  updatePassword(String email, String password, String newPassword) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      credential.user.updatePassword(newPassword);
      return '200';
    } catch (e) {
      return e.code.toString();
    }
  }

  createFirestoreEntry(String name, String email, {String image = ''}) async {
    try {
      Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'image': '$image',
        "status": "Hey there ! I'm using messenger",
      };
      await FirebaseFirestore.instance.collection('users').add(data);
      return '200';
    } catch (e) {
      return e.code.toString();
    }
  }

  signUpWithEmail(String email, String password, String name) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await createFirestoreEntry(name, email);

      return '200';
    } catch (e) {
      return e.toString();
    }
  }

  signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await storeMyData(email);
      await Util.updatePref(email);
      return '200';
    } catch (e) {
      return e.code.toString();
    }
  }

  storeMyData(String email) async {
    await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      Util.myData = value.docs[0].data();
      Util.myData['id'] = value.docs[0].id;
    });
  }

  signUpWithGoogle(controller) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;

      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      controller.startLoading();
      await _auth.signInWithCredential(credentials);
      await _firestore
          .collection('users')
          .where('email', isEqualTo: _auth.currentUser.email)
          .get()
          .then((value) {
        if (value.docs.length == 0) {
          createFirestoreEntry(
              _auth.currentUser.displayName, _auth.currentUser.email);
        }
      });
      await storeMyData(_auth.currentUser.email);
      await Util.storePref(_auth.currentUser.email);
      return '200';
    } catch (e) {
      return e.code.toString();
    }
  }

  deleteAccount(String email, String password, controller) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      controller.stopLoading();
      Get.offAll(() => AppIntro(),
          transition: Transition.topLevel,
          duration: Duration(milliseconds: 500));
      if (credential.user != null) {
        credential.user.delete();
        await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get()
            .then((value) {
          value.docs[0].reference.delete();
        });
      }
      return '200';
    } catch (e) {
      return e.code.toString();
    }
  }
}
