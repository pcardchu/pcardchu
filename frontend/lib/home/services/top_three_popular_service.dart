import 'package:dio/dio.dart';
import 'package:frontend/home/models/top_three_consume_model.dart';
import 'package:frontend/utils/dio_util.dart';
import 'package:frontend/home/models/top_three_consume_response.dart';
import 'package:frontend/home/models/top_three_popular_model.dart';
import 'package:frontend/home/models/top_three_popular_response.dart';

class TopThreePopularService {
  final dio = Dio();

  // Future<List<TopThreePopularModel>> getTopThreePopularCategory() async {
  //   try {
  //     final response = await DioUtil().dio.get('/statistics/top3category');
  //
  //
  //     final responseData = TopThreePopularResponse.fromJson(response.data);
  //
  //     if (responseData.status == 200) {
  //       // 성공적으로 데이터를 받았을 때의 처리
  //       return responseData.data;
  //     } else {
  //       // 서버에서 에러 응답이 왔을 때의 처리
  //       throw Exception('Failed to load top 3 categories: ${responseData.message}');
  //     }
  //   } on DioException catch (e) {
  //     // 네트워크 요청 중 에러가 발생했을 때의 처리
  //     throw Exception('Failed to load top 3 categories: ${e.message}');
  //   }
  // }

  Future<List<TopThreePopularModel>> getTopThreePopularCategory() async {
    // 2초의 딜레이를 가진 후 더미 데이터 반환
    return Future.delayed(const Duration(seconds: 1), () => _getDummyData());
  }

  List<TopThreePopularModel> _getDummyData() {
    // 더미 데이터 리스트 정의
    return [
      TopThreePopularModel(
        age: "30대",
        gender: "여성",
        categoryList: ["신한카드", "하나카드", "농협카드"],
      ),
      TopThreePopularModel(
        age: "40대",
        gender: "남성",
        categoryList: ["신한카드", "하나카드", "농협카드"],
      ),
      // 추가 데이터...
      TopThreePopularModel(
        age: "20대",
        gender: "남성",
        categoryList: ["신한카드", "하나카드", "농협카드"],
      ),
      TopThreePopularModel(
        age: "10대",
        gender: "여성",
        categoryList: ["신카드", "하카드", "농카드"],
      ),
      // 이곳에 추가 데이터 입력...
    ];
  }


}

