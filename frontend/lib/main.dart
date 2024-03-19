import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:frontend/user/screens/login_screen.dart';
import 'package:frontend/user/screens/splash_screen.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'providers/login_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
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
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: SplashScreen(),
      ),
    );
  }
}
