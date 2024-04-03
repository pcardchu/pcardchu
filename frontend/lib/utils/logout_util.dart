import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/providers/card_list_provider.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/providers/top_three_consume_provider.dart';
import 'package:frontend/providers/user_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutUtil {

  static void resetAllProviders(BuildContext context) async {
    final storage = const FlutterSecureStorage();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    await storage.deleteAll();
    // Provider.of<CardListProvider>(context, listen: false).reset();
    Provider.of<LoginProvider>(context, listen: false).reset();
    // Provider.of<ConsumptionProvider>(context, listen: false).reset();
    Provider.of<PasswordProvider>(context, listen: false).reset();
    // Provider.of<TopThreeConsumeProvider>(context, listen: false).reset();
    Provider.of<UserInfoProvider>(context, listen: false).reset();
    //
    
    print('로그아웃 완료 :');
  }
}