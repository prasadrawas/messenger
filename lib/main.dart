import 'package:firebase_core/firebase_core.dart';
import 'package:messenger/controllers/loading_controller.dart';
import 'package:messenger/controllers/password_controller.dart';
import 'package:messenger/utils/reusable_widgets.dart';
import 'package:messenger/utils/util.dart';
import 'package:messenger/views/auth/app_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:messenger/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Map<int, Color> color = {
    //   50: Color.fromRGBO(136, 14, 79, .1),
    // };
    return Parent(
      child: GetMaterialApp(
        title: 'Bookify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Poppins',
          primaryColor: Colors.blueAccent,
        ),
        home: FutureBuilder(
          future: Util.checkPref(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Splash();
            } else {
              Util.email = snapshot.data;
              return snapshot.data==null ? AppIntro() : Home();
            }
          },
        ),
      ),
    );
  }
}

class Parent extends StatefulWidget {
  final child;
  static final passwordController = Get.put(PasswordController());
  static final loadingController = Get.put(LoadingController());
  static final googleLoadingController = Get.put(GoogleLoadingController());
  Parent({Key key, this.child}) : super(key: key);
  @override
  _ParentState createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height(context),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: Image.asset('assets/images/splash_cover.png'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Messenger',
                      style: TextStyle(
                          color: TextColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 60,
                child: Center(
                  child: Text('From prasad'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
