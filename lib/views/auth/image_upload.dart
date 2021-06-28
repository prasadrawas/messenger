import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/controllers/loading_controller.dart';
import 'package:messenger/utils/ImageOperations.dart';
import 'package:messenger/utils/reusable_widgets.dart';
import 'package:messenger/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadImage extends StatefulWidget {
  final _email;
  UploadImage(this._email);
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File _imgFile = null;

  ImageOperations operations = ImageOperations();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF424242)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: LayoutBuilder(builder: (context, constraints) {
              if (orientation(context) == Orientation.portrait) {
                return portraitView(height(context));
              } else {
                return portraitView(width(context));
              }
            }),
          ),
        ),
      ),
    );
  }

  Column portraitView(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        uiTitle(height, 'Upload image'),
        uploadImageCard(height),
        altText(),
        SizedBox(
          height: height * 0.1,
        ),
        continueButton(height),
      ],
    );
  }

  Widget altText() {
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

  Widget continueButton(height) {
    return Center(
      child: GetBuilder<LoadingController>(
          init: LoadingController(),
          builder: (controller) {
            return Container(
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
                  onPressed: controller.isLoading
                      ? () {
                          controller.stopLoading();
                        }
                      : () async {
                          controller.startLoading();
                          await operations.uploadImage(_imgFile, widget._email);
                          controller.stopLoading();
                          Get.to(() => Home(),
                              transition: Transition.topLevel,
                              duration: Duration(milliseconds: 500));
                        },
                  child: controller.isLoading
                      ? loadingButtonText('Uploading', height)
                      : buttonText('Continiue', height),
                ),
              ),
            );
          }),
    );
  }

  Widget uploadImageCard(height) {
    return InkWell(
      borderRadius: BorderRadius.circular(height * 0.5),
      onTap: () {
        _pickImageFromDevice();
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
                child: _imgFile == null
                    ? Image.asset(
                        'assets/images/uploadImg_cover.png',
                        scale: 1,
                      )
                    : Image.file(_imgFile),
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

  Future<void> _pickImageFromDevice() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      snackBar('No image selected', 'retry');
    } else {
      _imgFile = File(pickedFile.path);
      _imgFile = await operations.cropImage(_imgFile);
      if (mounted) {
        setState(() {});
      }
    }
  }
}
