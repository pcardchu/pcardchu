import 'package:dio/dio.dart';
import 'package:frontend/card/models/card_detail_response.dart';
import 'package:frontend/utils/dio_util.dart';
import '../models/card_detail_model.dart';

class CardDetailService {
  final dio = Dio();

  /// 내 소비 패턴 정보 GET 요청
  Future<CardDetailModel> getMyCardDetail(String id) async {
    try {
      final Response response = await DioUtil()
          .dio
          .get("/cards/my-cards/$id", queryParameters: {'cardId': id});

      final responseData = CardDetailResponse.fromJson(response.data);

      if (responseData.status == 200) {
        return responseData.data;
      } else {
        throw Exception('Failed to load card detail: ${responseData.message}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // 에러코드에 따른 처리
        throw Exception('Failed to load card detail: ${e.response}');
      } else {
        print(e.requestOptions);
        print(e.message);
        throw Exception('Failed to load card detail: ${e.message}');
      }
    }
  }


//   Future<CardDetailModel> getMyCardDetail(String id) async {
//     // 2초의 딜레이를 가진 후 더미 데이터 반환
//     return Future.delayed(const Duration(seconds: 1), () => _getCardDetailDummyData());
//   }
//
//   CardDetailModel _getCardDetailDummyData() {
//     // 더미 데이터 생성
//     return CardDetailModel(
//       cardImage: "https://pickachu.s3.ap-northeast-2.amazonaws.com/images/528_NH농협카드_라이언치즈체크카드.png",
//       cardName: "My Credit Card",
//       cardCompany: "Best Bank",
//       useMoneyMonth: 500000,
//       todayUseHistory: [
//         UsageHistory(
//           category: "식사",
//           amount: 20000,
//           date: "2024-04-05",
//           time: 123456,
//         ),
//         UsageHistory(
//           category: "교통",
//           amount: 20000,
//           date: "2024-04-05",
//           time: 123457,
//         ),
//         UsageHistory(
//           category: "카페",
//           amount: 10000,
//           date: "2024-04-05",
//           time: 123457,
//         ),
//         UsageHistory(
//           category: "식사",
//           amount: 12000,
//           date: "2024-04-05",
//           time: 123457,
//         ),
//       ],
//       useBenefit: {
//         "푸드": 1500,
//         "교통": 2000,
//         "의료": 2000,
//         "여행": 2000,
//
//       },
//     );
//   }
}
