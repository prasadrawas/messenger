import 'package:messenger/controllers/loading_controller.dart';
import 'package:messenger/utils/Authentication.dart';
import 'package:messenger/utils/reusable_widgets.dart';
import 'package:messenger/views/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messenger/views/home.dart';

class Login extends StatelessWidget {
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
                    return verticalView(height(context));
                  } else {
                    return horizantalView(width(context));
                  }
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget horizantalView(double width) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Column(
            children: [
              coverImage('assets/images/login_cover.png'),
              SizedBox(
                height: 40,
              ),
              signupMessage(width),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              uiTitle(width, 'Log in'),
              EmailTextField(width, _email),
              PasswordTextField(width, _password),
              loginButton(width),
              altLoginText(width),
              loginBySocialMedia(width),
            ],
          ),
        )
      ],
    );
  }

  Widget verticalView(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        coverImage('assets/images/login_cover.png'),
        uiTitle(height, 'Log in'),
        EmailTextField(height, _email),
        PasswordTextField(height, _password),
        loginButton(height),
        altLoginText(height),
        loginBySocialMedia(height),
        signupMessage(height),
      ],
    );
  }

  Widget altLoginText(height) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 20),
      child: Text(
        'Or, Log in with...',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: height * 0.017, color: Color(0xFF424242)),
      ),
    );
  }

  Widget signupMessage(height) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New to messenger ? ',
          style: TextStyle(
            fontSize: height * 0.018,
            color: Color(0xFF424242),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.to(() => Signup(),
                transition: Transition.topLevel,
                duration: Duration(milliseconds: 500));
          },
          child: Text(
            'Sign up here',
            style: TextStyle(
                fontSize: height * 0.018,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget loginBySocialMedia(height) {
    return GetBuilder<GoogleLoadingController>(
        init: GoogleLoadingController(),
        builder: (controller) {
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: controller.isLoading
                ? null
                : () async {
                    _signinWithGoogle(controller);
                  },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFeceff1)),
                  borderRadius: BorderRadius.circular(10)),
              height: height * 0.0600,
              padding: EdgeInsets.all(10),
              child: controller.isLoading
                  ? googleButtonLoadingText('Login with', height)
                  : googleButtonText('Login with'),
            ),
          );
        });
  }

  Future _signinWithGoogle(GoogleLoadingController controller) async {
    Authentication auth = Authentication();
    var result = await auth.signUpWithGoogle(controller);
    controller.stopLoading();
    if (result == '200') {
      Get.to(() => Home(),
          transition: Transition.topLevel,
          duration: Duration(milliseconds: 500));
    } else {
      snackBar('Failed', result);
    }
  }

  Widget loginButton(height) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        height: height * 0.056,
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
                          await _signInWithEmail(controller);
                        },
                  child: controller.isLoading
                      ? loadingButtonText('Log in', height)
                      : buttonText('Log in', height),
                );
              }),
        ),
      ),
    );
  }

  Future _signInWithEmail(LoadingController controller) async {
    String email = _email.text.trim().toLowerCase();
    String password = _password.text.trim();
    controller.startLoading();
    var result = await Authentication().signInWithEmail(email, password);
    if (result == '200') {
      controller.stopLoading();
      Get.to(() => Home(),
          transition: Transition.topLevel,
          duration: Duration(milliseconds: 500));
    } else {
      controller.stopLoading();
      snackBar('Failed', result.toString());
    }
  }
}
