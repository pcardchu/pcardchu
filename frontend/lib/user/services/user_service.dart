import 'package:dio/dio.dart';
import 'package:frontend/user/models/user_info.dart';
import 'package:frontend/utils/dio_util.dart';

class UserService {
  final Dio _dio = DioUtil().dio;

  Future<UserInfo> getUserInfo() async {
    try {
      print("유저 정보 요청");
      Response response = await _dio.get('/user/info');

      print('유저 정보 : ${response.data}');

      return UserInfo.fromJson(response.data);
    } on DioException catch(e) {
      print('유저 정보 요청 오류 : $e');
      return UserInfo.empty();
    }

  }
}