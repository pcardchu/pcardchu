import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:frontend/providers/card_list_provider.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/providers/user_info_provider.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:frontend/user/screens/splash_screen.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'providers/login_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  /// intl을 사용하기 위해선 초기화를 한번 해줘야한다.
  await initializeDateFormatting();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  try {
    await dotenv.load(fileName: ".env");
    KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);
  } catch (e) {
    print("환경 변수 로딩 중 오류 발생: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/images/kakao_logo.png'), context);
    ScreenUtil.init(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => PasswordProvider()),
        ChangeNotifierProvider(create: (context) => CardProvider()),
        ChangeNotifierProvider(create: (_) => UserInfoProvider()),
        ChangeNotifierProvider(create: (context) => ConsumptionProvider()),
        ChangeNotifierProvider(create: (context) => CardListProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // 디버그 표시 제거
        theme: AppTheme.lightTheme,
        home: SplashScreen(),
      ),
    );
  }
}
