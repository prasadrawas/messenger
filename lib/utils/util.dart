import 'package:messenger/utils/Authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {
  static SharedPreferences pref;
  static String email;
  static Map<String, dynamic> myData = {};

  static Future<void> initializePref() async {
    pref = await SharedPreferences.getInstance();
  }

  static storePref(String email) async {
    if (pref == null) await initializePref();
    pref.setString('email', email);
  }

  static checkPref() async {
    if (pref == null) await initializePref();
    var res = pref.getString('email');
    if(res!=null) await await Authentication().storeMyData(res);
    await Future.delayed(Duration(seconds: 1));
    return res;
  }

  static Future<void> clearPref() async {
    if (pref == null) await initializePref();
    pref.clear();
  }

  static updatePref(String email) async {
    Util.email = email;
    if (pref == null) await initializePref();
    pref.setString('email', email);
    await Future.delayed(Duration(seconds: 1));
  }
}
