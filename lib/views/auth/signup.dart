import 'package:messenger/controllers/loading_controller.dart';
import 'package:messenger/utils/Authentication.dart';
import 'package:messenger/utils/reusable_widgets.dart';
import 'package:messenger/utils/util.dart';
import 'package:messenger/views/auth/image_upload.dart';
import 'package:messenger/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:messenger/views/home.dart';

class Signup extends StatelessWidget {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: LayoutBuilder(builder: (context, constraints) {
                  if (orientation(context) == Orientation.portrait) {
                    return portraintView(height(context));
                  } else {
                    return landscapeView(width(context));
                  }
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row landscapeView(double width) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Column(
            children: [
              coverImage('assets/images/signup_cover.png'),
              SizedBox(
                height: 40,
              ),
              loginMessage(width),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              uiTitle(width, 'Sign up'),
              SimpleTextField(
                  width, _name, 'Jon Doe', 'Full name', FontAwesomeIcons.user),
              EmailTextField(width, _email),
              PasswordTextField(width, _password),
              signupButton(width)
            ],
          ),
        ),
      ],
    );
  }

  Column portraintView(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        coverImage('assets/images/signup_cover.png'),
        uiTitle(height, 'Sign up'),
        signUpBySocialMedia(height),
        altSignUpText(height),
        SimpleTextField(
            height, _name, 'Jon Doe', 'Full name', FontAwesomeIcons.user),
        EmailTextField(height, _email),
        PasswordTextField(height, _password),
        signupButton(height),
        loginMessage(height),
      ],
    );
  }

  Widget loginMessage(height) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already signup ? ',
            style: TextStyle(
              fontSize: height * 0.018,
              color: Color(0xFF424242),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.to(() => Login(),
                  transition: Transition.topLevel,
                  duration: Duration(milliseconds: 500));
            },
            child: Text(
              'Log in here',
              style: TextStyle(
                  fontSize: height * 0.018,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget signupButton(height) {
    return Center(
      child: Container(
        height: height * 0.056,
        margin: EdgeInsets.only(top: 20, bottom: 20),
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: GetBuilder<LoadingController>(
              init: LoadingController(),
              builder: (controller) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        controller.isLoading
                            ? Colors.blue.withOpacity(0.8)
                            : null),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: controller.isLoading
                      ? () {}
                      : () async {
                          await _signUpWithEmail(controller);
                        },
                  child: controller.isLoading
                      ? loadingButtonText('Sign up', height)
                      : buttonText('Sign up', height),
                );
              }),
        ),
      ),
    );
  }

  Widget altSignUpText(height) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 10, top: 15),
      child: Text(
        'Or, Sign up with...',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: height * 0.017, color: Color(0xFF424242)),
      ),
    );
  }

  Widget signUpBySocialMedia(height) {
    return GetBuilder<GoogleLoadingController>(
        init: GoogleLoadingController(),
        builder: (controller) {
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: controller.isLoading
                ? null
                : () async {
                    _signUpWithGoogle(controller);
                  },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFeceff1)),
                  borderRadius: BorderRadius.circular(10)),
              height: height * 0.0600,
              padding: EdgeInsets.all(10),
              child: controller.isLoading
                  ? googleButtonLoadingText('Signing up', height)
                  : googleButtonText('Sign up With'),
            ),
          );
        });
  }

  Future _signUpWithGoogle(GoogleLoadingController controller) async {
    var result = await Authentication().signUpWithGoogle(controller);
    controller.stopLoading();
    if (result == '200') {
      Get.to(() => Home(),
          transition: Transition.topLevel,
          duration: Duration(milliseconds: 500));
    } else {
      snackBar('Failed', result);
    }
  }

  Future _signUpWithEmail(LoadingController controller) async {
    String name = _name.text.trim().capitalize;
    String email = _email.text.trim().toLowerCase();
    String password = _password.text.trim();
    controller.startLoading();
    Authentication auth = Authentication();
    var authResult = await auth.signUpWithEmail(email, password, name);

    if (authResult == '200') {
      await Util.storePref(email);
      controller.stopLoading();
      Get.off(() => UploadImage(email),
          transition: Transition.topLevel,
          duration: Duration(milliseconds: 300));
    } else {
      controller.stopLoading();
      snackBar('Auth Failed', authResult.toString());
    }
  }
}
