import 'package:get/state_manager.dart';

class LoadingController extends GetxController {
  bool isLoading = false;

  startLoading() {
    isLoading = true;
    update();
  }

  stopLoading() {
    isLoading = false;
    update();
  }
}


class GoogleLoadingController extends GetxController {
  bool isLoading = false;

  startLoading() {
    isLoading = true;
    update();
  }

  stopLoading() {
    isLoading = false;
    update();
  }
}
