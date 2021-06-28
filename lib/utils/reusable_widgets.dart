import 'package:messenger/controllers/password_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:messenger/models/user.dart';

Color TextColor = Color(0xFF424242);

height(context) {
  return MediaQuery.of(context).size.height;
}

width(context) {
  return MediaQuery.of(context).size.width;
}

orientation(context) {
  return MediaQuery.of(context).orientation;
}

Widget altLoginText(height) {
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(bottom: 20),
    child: Text(
      'Or, Sign up with...',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: height * 0.017, color: Color(0xFF424242)),
    ),
  );
}

buttonText(text, height) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: height * 0.0180,
    ),
  );
}

googleButtonText(text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        text,
        style: TextStyle(color: TextColor, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: 10,
      ),
      Image.asset('assets/images/google_logo.png'),
    ],
  );
}

googleButtonLoadingText(text, height) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        text,
        style: TextStyle(color: TextColor, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: 10,
      ),
      loadingAnimation(height),
    ],
  );
}

loadingButtonText(text, height) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: height * 0.0180,
        ),
      ),
      loadingAnimation(height),
    ],
  );
}

loadingAnimation(height) {
  return Container(
    margin: EdgeInsets.only(
      left: 10,
    ),
    height: height * 0.030,
    width: height * 0.030,
    child: CircularProgressIndicator(
      strokeWidth: 1.4,
      backgroundColor: Colors.white,
    ),
  );
}

snackBar(title, message) {
  Get.rawSnackbar(
    title: title,
    message: message,
    duration: Duration(seconds: 1),
  );
}

sendersMessage(messege, time) {
  return FractionallySizedBox(
    widthFactor: 0.6,
    alignment: Alignment.centerLeft,
    child: Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              messege,
              softWrap: true,
              textAlign: TextAlign.left,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              time,
              style: TextStyle(fontSize: 10, color: Colors.white70),
            )
          ],
        )),
  );
}

reciversMessage(messege, time) {
  return FractionallySizedBox(
    alignment: Alignment.centerRight,
    widthFactor: 0.6,
    child: Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          Text(
            messege,
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold, color: TextColor),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 10, color: Colors.black87),
          )
        ],
      ),
    ),
  );
}

contactCard(User user, {String sub=''}) {
  return Container(
    padding: EdgeInsets.all(3),
    child: Column(
      children: [
        ListTile(
          leading: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              viewContact();
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: user.image=="" ? CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/uploadImg_cover.png'),
              ): CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(user.image),
                backgroundColor: Colors.white,
              ),),
          ),
          title: Text(
            user.name,
            style: TextStyle(
              color: TextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(sub==''?user.status : sub, maxLines: 1,),
        ),
        Divider(
          thickness: 0.1,
          height: 0,
          color: TextColor,
        ),
      ],
    ),
  );
}

viewContact() {
  Get.defaultDialog(
    title: 'Vivek Sangvikar',
    content: FractionallySizedBox(
      widthFactor: 0.5,
      child: Column(
        children: [
          Image.asset('assets/images/uploadImg_cover.png'),
          Divider(
            thickness: 0.1,
            height: 5,
            color: TextColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.chat,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(
                    FontAwesomeIcons.infoCircle,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {})
            ],
          )
        ],
      ),
    ),
  );
}

Widget EmailTextField(height, textEditingController) {
  return Container(
    margin: EdgeInsets.only(bottom: height * 0.010, top: height * 0.025),
    child: TextFormField(
      controller: textEditingController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: height * 0.018),
      validator: (s) {
        return RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(s)
            ? null
            : 'Please enter valid email';
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          hintText: 'jondoe@example.com',
          labelText: 'Email Address',
          prefixIcon: Icon(
            FontAwesomeIcons.envelope,
            size: height * 0.018,
          ),
          suffixStyle: TextStyle(color: Colors.green)),
    ),
  );
}

Widget SimpleTextField(height, textEditingController, hint, label, icon) {
  return Container(
    margin: EdgeInsets.only(bottom: height * 0.010, top: height * 0.025),
    child: TextFormField(
      controller: textEditingController,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontSize: height * 0.018),
      validator: (s) {
        return s.trim().isEmpty ? 'Please enter valid text' : null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintText: hint,
        labelText: label,
        prefixIcon: Icon(
          icon,
          size: height * 0.018,
        ),
      ),
    ),
  );
}

Widget PasswordTextField(height, textEditingController, {labelText=''}) {
  return GetBuilder<PasswordController>(
      init: PasswordController(),
      builder: (controller) {
        return Container(
          margin: EdgeInsets.only(bottom: height * 0.010, top: height * 0.025),
          child: TextFormField(
            controller: textEditingController,
            obscureText: controller.clicked,
            validator: (s) {
              return s.trim().isEmpty ? 'Please enter valid password' : null;
            },
            style: TextStyle(fontSize: height * 0.018),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                labelText: labelText==''?'Password':labelText,
                prefixIcon: Icon(
                  FontAwesomeIcons.lock,
                  size: height * 0.018,
                ),
                suffixIcon: IconButton(
                  icon: Icon(controller.clicked
                      ? FontAwesomeIcons.eye
                      : FontAwesomeIcons.eyeSlash),
                  iconSize: height * 0.018,
                  onPressed: () {
                    controller.toggleClick();
                  },
                ),
                suffixStyle: TextStyle(color: Colors.green)),
          ),
        );
      });
}

Widget MessageTextField(height, textEditingController) {
  return Container(
    height: 55,
    color: Colors.white,
    margin: EdgeInsets.only(
      bottom: height * 0.010,
    ),
    child: TextFormField(
      controller: textEditingController,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintText: 'Type a message',
        prefixIcon: Icon(
          Icons.message,
          size: 18,
        ),
      ),
    ),
  );
}

uiTitle(height, title) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 35, color: Color(0xFF424242)),
    ),
  );
}

coverImage(imgPath) {
  return FractionallySizedBox(
    widthFactor: 1,
    alignment: Alignment.center,
    child: Center(
      child: Image.asset(
        imgPath,
      ),
    ),
  );
}
