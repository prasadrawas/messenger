import 'package:get/get.dart';

class PasswordController extends GetxController {
  bool clicked = true;
  toggleClick() {
    clicked = !clicked;
    update();
  }
}
