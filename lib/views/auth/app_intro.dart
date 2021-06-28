import 'package:messenger/utils/reusable_widgets.dart';
import 'package:messenger/views/auth/login.dart';
import 'package:messenger/views/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              if (orientation(context) == Orientation.portrait) {
                return portraitView(height(context));
              } else {
                return landscapeView(width(context));
              }
            }),
          ),
        ),
      ),
    );
  }

  portraitView(height) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        introImage(),
        introText(height),
        getStatedButton(height),
        loginButton(),
      ],
    );
  }

  landscapeView(width) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: introImage(),
        ),
        Flexible(
          flex: 1,
          child: Column(
            children: [
              introText(width),
              getStatedButton(width),
              loginButton(),
            ],
          ),
        )
      ],
    );
  }

  introImage() {
    return FractionallySizedBox(
        alignment: Alignment.center,
        widthFactor: 0.8,
        child: Container(child: Image.asset('assets/images/intro_cover.png')));
  }

  introText(height) {
    return Column(
      children: [
        Text(
          'Connect Together',
          style:
              TextStyle(fontSize: height * 0.028, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: height * 0.010,
        ),
        Text(
          'Connecting peoples with each other is more important than connecting your devices with each other.',
          textAlign: TextAlign.center,
          style:
              TextStyle(fontSize: height * 0.015, fontWeight: FontWeight.w100),
        ),
        SizedBox(
          height: height * 0.050,
        ),
      ],
    );
  }

  getStatedButton(height) {
    return Container(
      height: height * 0.060,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => Signup(),
                transition: Transition.topLevel,
                duration: Duration(milliseconds: 500));
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ))),
          child: Text('Get Started'),
        ),
      ),
    );
  }

  loginButton() {
    return TextButton(
      onPressed: () {
        Get.to(() => Login(),
            transition: Transition.topLevel,
            duration: Duration(milliseconds: 500));
      },
      child: Text(
        'Login',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
