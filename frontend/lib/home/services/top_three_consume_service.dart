import 'package:dio/dio.dart';
import 'package:frontend/home/models/top_three_consume_model.dart';
import 'package:frontend/utils/dio_util.dart';
import 'package:frontend/home/models/top_three_consume_response.dart';

class TopThreeConsumeService {
  final dio = Dio();

  Future<List<TopThreeConsumeModel>> getTopThreeCategory() async {
    try {
      final response = await DioUtil().dio.get('/statistics/top3category');


      final responseData = TopThreeConsumeResponse.fromJson(response.data);
      print(responseData.data);
      if (responseData.status == 200) {
        // 성공적으로 데이터를 받았을 때의 처리
        return responseData.data;
      } else {
        // 서버에서 에러 응답이 왔을 때의 처리
        throw Exception('Failed to load top 3 categories: ${responseData.message}');
      }
    } on DioException catch (e) {
      // 네트워크 요청 중 에러가 발생했을 때의 처리
      throw Exception('Failed to load top 3 categories: ${e.message}');
    }
  }

  // Future<List<TopThreeConsumeModel>> getTopThreeCategory() async {
  //   // 2초의 딜레이를 가진 후 더미 데이터 반환
  //   return Future.delayed(const Duration(seconds: 4), () => _getDummyData());
  // }
  //
  // List<TopThreeConsumeModel> _getDummyData() {
  //   // 더미 데이터 리스트 정의
  //   return [
  //     TopThreeConsumeModel(
  //       age: "30대",
  //       gender: "여성",
  //       categoryList: ["전자상거래PG", "편의점", "슈퍼"],
  //     ),
  //     TopThreeConsumeModel(
  //       age: "40대",
  //       gender: "남성",
  //       categoryList: ["편의점", "슈퍼", "한식"],
  //     ),
  //     // 추가 데이터...
  //     TopThreeConsumeModel(
  //       age: "20대",
  //       gender: "남성",
  //       categoryList: ["편의점", "전자상거래PG", "비디오방/게임방"],
  //     ),
  //     TopThreeConsumeModel(
  //       age: "10대",
  //       gender: "여성",
  //       categoryList: ["편의점", "전자상거래PG", "커피/음료"],
  //     ),
  //     // 이곳에 추가 데이터 입력...
  //   ];
  // }


}

