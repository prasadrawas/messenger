import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/controllers/loading_controller.dart';
import 'package:messenger/utils/Authentication.dart';
import 'package:messenger/utils/ImageOperations.dart';
import 'package:messenger/utils/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/utils/util.dart';
import 'package:messenger/views/auth/app_intro.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  File _imgFile = null;
  Authentication auth = Authentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: Util.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      height: height(context),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }

                  return LayoutBuilder(builder: (context, constraints) {
                    if (orientation(context) == Orientation.portrait) {
                      return portraitView(
                          height(context), snapshot.data.docs[0]);
                    } else {
                      return landscapeView(
                          width(context), snapshot.data.docs[0]);
                    }
                  });
                }),
          ),
        ),
      ),
    );
  }

  appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF424242)),
    );
  }

  Column portraitView(double height, snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        uiTitle(height, snapshot['name']),
        uploadImageCard(height, snapshot['email'], snapshot['image']),
        altText(),
        SizedBox(
          height: height * 0.1,
        ),
        InkWell(
          onTap: () {
            updateDataDialogBox(height, 'status');
          },
          child: settingMenuEditable(
              height, FontAwesomeIcons.rocket, 'Status', snapshot['status']),
        ),
        InkWell(
          onTap: () {
            updateDataDialogBox(height, 'name');
          },
          child: settingMenuEditable(
              height, FontAwesomeIcons.userAlt, 'Name', snapshot['name']),
        ),
        InkWell(
          onTap: () {
            updateEmailDialogBox(height, Util.email);
          },
          child: settingMenuEditable(height, FontAwesomeIcons.solidEnvelope,
              'Email', snapshot['email']),
        ),
        InkWell(
          onTap: () {
            updatePasswordDilaogBox(height, Util.email);
          },
          child: settingMenuEditable(
              height, FontAwesomeIcons.lock, 'Password', '*****'),
        ),
        InkWell(
          onTap: () {},
          child: settingMenu(height, FontAwesomeIcons.affiliatetheme, 'Theme',
              'Change theme (dark/light)'),
        ),
        InkWell(
          onTap: () {
            deleteAccountDialogBox(height, Util.email);
          },
          child: settingMenu(height, FontAwesomeIcons.trash, 'Delete Account',
              'Delete account permently'),
        ),
        InkWell(
          onTap: () {
            _logoutFromApp();
          },
          child: settingMenu(height, FontAwesomeIcons.signOutAlt, 'Logout',
              'Logout from messenger'),
        ),
      ],
    );
  }

  void _logoutFromApp() {
    Get.defaultDialog(
      title: 'Do you really want to logout ?',
      onConfirm: () {
        Util.clearPref();
        Get.offAll(() => AppIntro(),
            transition: Transition.topLevel,
            duration: Duration(milliseconds: 500));
      },
      onCancel: () {
        Get.back();
      },
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
    );
  }

  Row landscapeView(double height, snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: Column(
            children: [
              uiTitle(height, snapshot['name']),
              uploadImageCard(height, snapshot['email'], snapshot['image']),
              altText(),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  updateDataDialogBox(height, 'status');
                },
                child: settingMenuEditable(height, FontAwesomeIcons.rocket,
                    'Status', snapshot['status']),
              ),
              InkWell(
                onTap: () {
                  updateDataDialogBox(height, 'name');
                },
                child: settingMenuEditable(
                    height, FontAwesomeIcons.userAlt, 'Name', snapshot['name']),
              ),
              InkWell(
                onTap: () {
                  updateEmailDialogBox(height, Util.email);
                },
                child: settingMenuEditable(height,
                    FontAwesomeIcons.solidEnvelope, 'Email', snapshot['email']),
              ),
              InkWell(
                onTap: () {
                  updatePasswordDilaogBox(height, Util.email);
                },
                child: settingMenuEditable(
                    height, FontAwesomeIcons.lock, 'Password', '*****'),
              ),
              InkWell(
                onTap: () {},
                child: settingMenu(height, FontAwesomeIcons.affiliatetheme,
                    'Theme', 'Change theme (dark/light)'),
              ),
              InkWell(
                onTap: () {
                  deleteAccountDialogBox(height, Util.email);
                },
                child: settingMenu(height, FontAwesomeIcons.trash,
                    'Delete Account', 'Delete account permently'),
              ),
              InkWell(
                onTap: () {
                  _logoutFromApp();
                },
                child: settingMenu(height, FontAwesomeIcons.signOutAlt,
                    'Logout', 'Logout from messenger'),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget updateDataDialogBox(height, updateField) {
    final textController = TextEditingController();
    Get.defaultDialog(
        title: 'Update $updateField',
        content: Container(
          child: Column(
            children: [
              SimpleTextField(
                  height, textController, '', '$updateField', Icons.edit),
              GetBuilder<LoadingController>(
                  init: LoadingController(),
                  builder: (controller) {
                    return FractionallySizedBox(
                      widthFactor: 0.6,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              controller.isLoading
                                  ? Colors.blue.withOpacity(0.8)
                                  : null),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: controller.isLoading
                            ? () {}
                            : () async {
                                String data =
                                    textController.text.capitalize.trim();
                                controller.startLoading();
                                var result = updateField == 'status'
                                    ? await auth.updateStatus(Util.email, data)
                                    : await auth.updateName(Util.email, data);
                                controller.stopLoading();
                                Get.back();
                                if (result == '200') {
                                  snackBar('Success',
                                      '$updateField changed successfully.');
                                } else {
                                  snackBar('Failed', result.toString());
                                }
                              },
                        child: controller.isLoading
                            ? loadingButtonText('Updating', height)
                            : buttonText('Update', height),
                      ),
                    );
                  }),
            ],
          ),
        ));
  }

  Widget updateEmailDialogBox(height, email) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    Get.defaultDialog(
        title: 'Change Email',
        content: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              EmailTextField(height, emailController),
              PasswordTextField(height, passwordController,
                  labelText: 'Password'),
              SizedBox(
                height: height * 0.05,
              ),
              GetBuilder<LoadingController>(
                  init: LoadingController(),
                  builder: (controller) {
                    return ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            controller.isLoading
                                ? Colors.blue.withOpacity(0.8)
                                : null),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: controller.isLoading
                          ? () {}
                          : () async {
                              String newEmail =
                                  emailController.text.toLowerCase().trim();
                              String password = passwordController.text.trim();
                              controller.startLoading();
                              var result = await Authentication()
                                  .updateEmail(email, password, newEmail);
                              controller.stopLoading();
                              Get.back();
                              if (result == '200') {
                                snackBar('Email Changed',
                                    'Email changed Successfully.');
                              } else {
                                snackBar('Failed', result.toString());
                              }
                            },
                      child: controller.isLoading
                          ? loadingButtonText('Updating', height)
                          : buttonText('Update', height),
                    );
                  }),
            ],
          ),
        ));
  }

  Widget updatePasswordDilaogBox(height, email) {
    final oldPass = TextEditingController();
    final newPass = TextEditingController();
    Get.defaultDialog(
        title: 'Change Password',
        content: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              PasswordTextField(height, oldPass, labelText: 'Old Password'),
              PasswordTextField(height, newPass, labelText: 'New Password'),
              SizedBox(
                height: height * 0.05,
              ),
              GetBuilder<LoadingController>(
                  init: LoadingController(),
                  builder: (controller) {
                    return ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            controller.isLoading
                                ? Colors.blue.withOpacity(0.8)
                                : null),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: controller.isLoading
                          ? () {}
                          : () async {
                              String old = oldPass.text.trim();
                              String newP = newPass.text.trim();
                              controller.startLoading();
                              var result = await Authentication()
                                  .updatePassword(email, old, newP);
                              controller.stopLoading();
                              Get.back();
                              if (result == '200') {
                                snackBar('Password Changed',
                                    'Password changed Successfully.');
                              } else {
                                snackBar('Failed', result.toString());
                              }
                            },
                      child: controller.isLoading
                          ? loadingButtonText('Updating', height)
                          : buttonText('Update', height),
                    );
                  }),
            ],
          ),
        ));
  }

  Widget deleteAccountDialogBox(height, email) {
    final textController = TextEditingController();
    Get.defaultDialog(
        title: 'Delete Account Permently',
        content: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              PasswordTextField(height, textController),
              SizedBox(
                height: height * 0.05,
              ),
              GetBuilder<LoadingController>(
                  init: LoadingController(),
                  builder: (controller) {
                    return ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            controller.isLoading
                                ? Colors.blue.withOpacity(0.8)
                                : null),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: controller.isLoading
                          ? () {}
                          : () async {
                              controller.startLoading();
                              var result = await Authentication().deleteAccount(
                                  email, textController.text, controller);
                              controller.stopLoading();
                              if (result != '200') {
                                snackBar('Failed to delete', result.toString());
                              }
                            },
                      child: controller.isLoading
                          ? loadingButtonText('Deleting', height)
                          : buttonText('Delete', height),
                    );
                  }),
            ],
          ),
        ));
  }

  altText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Tap to upload new image',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: TextColor,
        ),
      ),
    );
  }

  continueButton(height) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        height: height * 0.056,
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            onPressed: () {},
            child: Text(
              'Continue',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: height * 0.0180,
              ),
            ),
          ),
        ),
      ),
    );
  }

  uploadImageCard(height, email, image) {
    return InkWell(
      borderRadius: BorderRadius.circular(height * 0.5),
      onTap: () {
        // _pickImageFromDevice(email);
      },
      child: Container(
        height: height * 0.3,
        width: height * 0.3,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFeceff1)),
          borderRadius: BorderRadius.circular(height * 0.5),
        ),
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height * 0.5),
                child: image == ""
                    ? Image.asset(
                        'assets/images/uploadImg_cover.png',
                        scale: 1,
                      )
                    : Image.network(image),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 40,
                width: 40,
                margin: EdgeInsets.only(top: 130),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(height * 0.5),
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromDevice(email) async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      snackBar('No image selected', 'retry');
    } else {
      ImageOperations operations = ImageOperations();
      _imgFile = File(pickedFile.path);
      _imgFile = await operations.cropImage(_imgFile);
      if (mounted) {
        setState(() {});
      }
      String url = await operations.uploadImage(_imgFile, email);
      operations.updateFirestoreEntry(url, email);
    }
  }

  settingMenuEditable(height, icon, title, subtitle) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
        size: height * 0.020,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: TextColor),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: TextColor),
      ),
      trailing: Icon(
        Icons.edit,
        color: TextColor,
        size: 17,
      ),
    );
  }

  settingMenu(height, icon, title, subtitle) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
        size: height * 0.020,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: TextColor),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: TextColor),
      ),
    );
  }
}
