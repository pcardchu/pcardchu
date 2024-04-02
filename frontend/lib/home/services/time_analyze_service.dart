import 'package:dio/dio.dart';

import 'package:frontend/utils/dio_util.dart';
import 'package:frontend/home/models/consume_differ_model.dart';
import '../models/time_analyze_model.dart';

class TimeAnalyzeService {
  final dio = Dio();

  Future<TimeAnalyzeModel> getTimeAnalyze() async {
    try {
      final response = await DioUtil().dio.get('/statistics/top3category');


      final responseData = TimeAnalyzeModel.fromJson(response.data);

      if (responseData.status == 200) {
        // 성공적으로 데이터를 받았을 때의 처리
        return responseData;
      } else {
        // 서버에서 에러 응답이 왔을 때의 처리
        throw Exception('Failed to load consume differ data: ${responseData.message}');
      }
    } on DioException catch (e) {
      // 네트워크 요청 중 에러가 발생했을 때의 처리
      throw Exception('Failed to load consume differ data: ${e.message}');
    }
  }

  // Future<TimeAnalyzeModel> getTimeAnalyze() async {
  //   // 2초의 딜레이를 가진 후 더미 데이터 반환
  //   return Future.delayed(const Duration(seconds: 4), () => _getDummyData());
  // }
  //
  // TimeAnalyzeModel _getDummyData() {
  //   // 더미 데이터 리스트 정의
  //   return TimeAnalyzeModel(
  //     status: 200,
  //     message: "Success",
  //     data: '10대',
  //   );
  // }


}

