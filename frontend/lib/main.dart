import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:frontend/providers/card_list_provider.dart';
import 'package:frontend/providers/card_provider.dart';
import 'package:frontend/providers/consume_differ_provider.dart';
import 'package:frontend/providers/consumption_provider.dart';
import 'package:frontend/providers/password_provider.dart';
import 'package:frontend/providers/time_analyze_provider.dart';
import 'package:frontend/providers/top_three_consume_provider.dart';
import 'package:frontend/providers/top_three_popular_provider.dart';
import 'package:frontend/providers/user_info_provider.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:frontend/user/screens/splash_screen.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:secure_application/secure_application.dart'; // secure_application 패키지 추가
import 'providers/login_provider.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

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
    precacheImage(const AssetImage('assets/images/kakao_logo.png'), context);
    ScreenUtil.init(context);

    return SecureApplication(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LoginProvider()),
          ChangeNotifierProvider(create: (context) => LoginProvider()),
          ChangeNotifierProvider(create: (context) => PasswordProvider()),
          ChangeNotifierProvider(create: (context) => CardProvider()),
          ChangeNotifierProvider(create: (context) => UserInfoProvider()),
          ChangeNotifierProvider(create: (context) => ConsumptionProvider()),
          ChangeNotifierProvider(create: (context) => CardListProvider()),
          ChangeNotifierProvider(create: (context) => TopThreeConsumeProvider()),
          ChangeNotifierProvider(create: (context) => TopThreePopularProvider()),
          ChangeNotifierProvider(create: (context) => ConsumeDifferProvider()),
          ChangeNotifierProvider(create: (context) => TimeAnalyzeProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: SecureGate(
            blurr: 0, // 백그라운드 블러 강도
            opacity: 0, // 백그라운드 블러 투명도
            lockedBuilder: (context, secureNotifier) =>
            Center(
              child: Image.asset('assets/images/app_icon.png'),
            ),
            child: SplashScreen(),
          ),
        ),
      ),
    );
  }
}
