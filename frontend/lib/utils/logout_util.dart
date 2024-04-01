import 'package:flutter/cupertino.dart';
import 'package:frontend/providers/card_list_provider.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/providers/top_three_consume_provider.dart';
import 'package:frontend/providers/user_info_provider.dart';
import 'package:provider/provider.dart';

class LogoutUtil {
  static void resetAllProviders(BuildContext context) {
    // Provider.of<CardListProvider>(context, listen: false).reset();
    Provider.of<LoginProvider>(context, listen: false).reset();
    // Provider.of<ConsumptionProvider>(context, listen: false).reset();
    Provider.of<PasswordProvider>(context, listen: false).reset();
    // Provider.of<TopThreeConsumeProvider>(context, listen: false).reset();
    Provider.of<UserInfoProvider>(context, listen: false).reset();
    //
  }
}