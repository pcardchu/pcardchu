import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/home/screens/bottom_nav_screen.dart';
import 'package:frontend/providers/login_provider.dart';
import 'package:frontend/user/models/jwt_token.dart';
import 'package:frontend/user/screens/password_screen.dart';
import 'package:frontend/user/widgets/kakao_login_button.dart';
import 'package:frontend/utils/dio_util.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/app_icon.png', width: ScreenUtil.w(70),),
            SizedBox(height: ScreenUtil.h(20),),
            ElevatedButton(
              onPressed: () async {
                //accessToken 강제로 가져오기
                final Dio dio = Dio();
                String url = "${dotenv.env['API_URL']}/auth-test/second";

                var header = {
                  'accept' : 'application/json',
                };

                try {
                  final Response response = await dio.get(
                    url,
                    options: Options(headers: header),
                  );

                  print("accessToken 강제 발급 : ${response.data}");
                  LoginProvider provider = Provider.of<LoginProvider>(context, listen: false);
                  provider.secondJwt = JwtToken(isFirst: false, refreshToken: null, accessToken: response.data['accessToken']);

                  //api 호출 테스트
                  // Response<dynamic> test = await DioUtil().dio.get('/user/info');
                  // print(test.data);

                } catch(e) {
                  print("accessToken 강제 발급 실패 : $e");
                }

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const BottomNavScreen(),
                  ),
                );
              },
              child: const Text('HOME'),
            ),
            SizedBox(
              width: ScreenUtil.w(85),
              child: KakaoLoginButton(),
            ),
          ],
        ) ,
      ),
    );
  }
}
