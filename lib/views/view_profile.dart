import 'package:messenger/models/user.dart';
import 'package:messenger/utils/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewProfile extends StatelessWidget {
  final User user;
  ViewProfile(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
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

  appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF424242)),
    );
  }

  Column portraitView(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        uiTitle(height, user.name),
        imageCard(height, user.image),
        SizedBox(
          height: height * 0.030,
        ),
        settingMenu(height, FontAwesomeIcons.rocket, 'Status',
            user.status),
        settingMenu(
            height, FontAwesomeIcons.userAlt, 'Name', user.name),
        settingMenu(height, FontAwesomeIcons.solidEnvelope, 'Email',
            user.email),
      
        settingMenu(height, Icons.block_rounded  ,'Block',
            'Block this contact'),
      ],
    );
  }

  Row landscapeView(double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: Column(
            children: [
              uiTitle(height, user.name),
              imageCard(height, user.image),
              altText(),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            children: [
            settingMenu(height, FontAwesomeIcons.rocket, 'Status',
                  user.status),
              settingMenu(
                  height, FontAwesomeIcons.userAlt, 'Name', user.name),
              settingMenu(height, FontAwesomeIcons.solidEnvelope, 'Email',
                  user.email),
            
              settingMenu(height, Icons.block_rounded  ,'Block',
                  'Block this contact'),
            ],
          ),
        )
      ],
    );
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

  uploadImageCard(height) {
    return InkWell(
      borderRadius: BorderRadius.circular(height * 0.5),
      onTap: () {},
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
                child: Image.asset(
                  'assets/images/uploadImg_cover.png',
                  scale: 1,
                ),
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


  imageCard(height, image) {
    return Container(
      height: height * 0.3,
      width: height * 0.3,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFeceff1)),
        borderRadius: BorderRadius.circular(height * 0.5),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(height * 0.5),
          child: image=="" ? Image.asset(
            'assets/images/uploadImg_cover.png',
            scale: 1,
          ) : Image.network(image),
        ),
      ),
    );
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
