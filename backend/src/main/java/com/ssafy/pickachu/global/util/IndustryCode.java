package com.ssafy.pickachu.global.util;

import java.util.HashMap;

public class IndustryCode {
    private static IndustryCode instance;
    public HashMap<Integer, String> industryCodeHashMap;

    // 외부에서 인스턴스를 생성하지 못하도록 private 생성자를 선언
    private IndustryCode() {
        industryCodeHashMap = new HashMap<>();
        industryCodeHashMap.put(1001, "맞춤복");
        industryCodeHashMap.put(1003, "한복");
        industryCodeHashMap.put(1004, "기성복");
        industryCodeHashMap.put(1007, "아동 및 유아복");
        industryCodeHashMap.put(1008, "내의판매");
        industryCodeHashMap.put(1010, "양품");
        industryCodeHashMap.put(1099, "기타 의류");
        industryCodeHashMap.put(1101, "옷감판매");
        industryCodeHashMap.put(1102, "침구, 커튼, 카펫트");
        industryCodeHashMap.put(1104, "수예");
        industryCodeHashMap.put(1105, "자석요");
        industryCodeHashMap.put(1199, "기타 직물");
        industryCodeHashMap.put(1201, "악세사리");
        industryCodeHashMap.put(1202, "귀금속");
        industryCodeHashMap.put(1203, "시계");
        industryCodeHashMap.put(1204, "안경");
        industryCodeHashMap.put(1205, "가방");
        industryCodeHashMap.put(1206, "제화");
        industryCodeHashMap.put(1207, "일반신발");
        industryCodeHashMap.put(1208, "가발");
        industryCodeHashMap.put(1299, "기타 신변잡화");

        industryCodeHashMap.put(2002, "휴게음식");
        industryCodeHashMap.put(2003, "제과/아이스크림");
        industryCodeHashMap.put(2004, "커피/음료");
        industryCodeHashMap.put(2099, "패스트푸드");

        industryCodeHashMap.put(2104, "한식");
        industryCodeHashMap.put(2107, "일식/생선횟집");
        industryCodeHashMap.put(2109, "중식");
        industryCodeHashMap.put(2110, "양식");
        industryCodeHashMap.put(2111, "뷔페");
        industryCodeHashMap.put(2112, "일반주점");
        industryCodeHashMap.put(2113, "패밀리레스토랑");
        industryCodeHashMap.put(2199, "일반음식점 기타");

        industryCodeHashMap.put(2401, "곡물");
        industryCodeHashMap.put(2402, "고기");
        industryCodeHashMap.put(2403, "인삼");
        industryCodeHashMap.put(2404, "건강식품");
        industryCodeHashMap.put(2407, "주류");
        industryCodeHashMap.put(2499, "반찬");

        industryCodeHashMap.put(3401, "건축자재");
        industryCodeHashMap.put(3402, "기계류 건축설비");
        industryCodeHashMap.put(3403, "철물점");
        industryCodeHashMap.put(3404, "실내장식");
        industryCodeHashMap.put(3405, "지물 및 천막");
        industryCodeHashMap.put(3407, "보안경비시스템");
        industryCodeHashMap.put(3408, "주택, 건설");
        industryCodeHashMap.put(3499, "기타 건축자재");

        industryCodeHashMap.put(2299, "단란주점");
        industryCodeHashMap.put(2312, "유흥주점");
        industryCodeHashMap.put(2317, "나이트클럽");
        industryCodeHashMap.put(4113, "노래방");
        industryCodeHashMap.put(7104, "안마시술소");
        industryCodeHashMap.put(7299, "유흥기타");

        industryCodeHashMap.put(3001, "일반가구");
        industryCodeHashMap.put(3002, "철재가구");

        industryCodeHashMap.put(3101, "가전제품");
        industryCodeHashMap.put(3102, "냉난방기구");
        industryCodeHashMap.put(3201, "조명 및 전기기구");
        industryCodeHashMap.put(3199, "기타 전자제품");

        industryCodeHashMap.put(3202, "주방기구점");
        industryCodeHashMap.put(3203, "주방 및 가정용품");
        industryCodeHashMap.put(3204, "정수기");
        industryCodeHashMap.put(3299, "기타 주방용품");

        industryCodeHashMap.put(6101, "사무용기기");
        industryCodeHashMap.put(6102, "정보통신기기");
        industryCodeHashMap.put(6103, "컴퓨터기기");
        industryCodeHashMap.put(6109, "피아노");
        industryCodeHashMap.put(6110, "기타 악기");

        industryCodeHashMap.put(5501, "국산자동차");
        industryCodeHashMap.put(5601, "수입자동차");
        industryCodeHashMap.put(5602, "중고자동차");
        industryCodeHashMap.put(5603, "오토바이");
        industryCodeHashMap.put(5502, "자전거");
        industryCodeHashMap.put(5604, "기타운송기구");
        industryCodeHashMap.put(5608, "주유소");
        industryCodeHashMap.put(5609, "충전소");
        industryCodeHashMap.put(5605, "차량 정비/부품/인테리어");
        industryCodeHashMap.put(5610, "주차장");
        industryCodeHashMap.put(5611, "세차장");
        industryCodeHashMap.put(5612, "차량견인업");
        industryCodeHashMap.put(5699, "기타 차량서비스");

        industryCodeHashMap.put(4001, "백화점");
        industryCodeHashMap.put(4107, "대형마트");
        industryCodeHashMap.put(4108, "직판장");
        industryCodeHashMap.put(4123, "대형쇼핑몰");

        industryCodeHashMap.put(4101, "슈퍼");
        industryCodeHashMap.put(4112, "편의점");
        industryCodeHashMap.put(4110, "일반잡화");
        industryCodeHashMap.put(4103, "소비조합");

        industryCodeHashMap.put(4104, "선물의집");
        industryCodeHashMap.put(4115, "전자상거래");
        industryCodeHashMap.put(4118, "전자상거래(Passcity)");
        industryCodeHashMap.put(4120, "전자상거래PG");
        industryCodeHashMap.put(4121, "전자상거래오픈마켓");
        industryCodeHashMap.put(4124, "전자상거래상품권");
        industryCodeHashMap.put(4125, "전자상거래PG상품권");
        industryCodeHashMap.put(4126, "전자상거래오픈마켓상품권");

        industryCodeHashMap.put(4106, "통신판매");

        industryCodeHashMap.put(3406, "농어업용품");
        industryCodeHashMap.put(4111, "중곰루품");
        industryCodeHashMap.put(4114, "종교상품");
        industryCodeHashMap.put(4198, "다단계");
        industryCodeHashMap.put(4200, "상품권");
        industryCodeHashMap.put(6117, "성인용품");
        industryCodeHashMap.put(8407, "자동판매기");
        industryCodeHashMap.put(4199, "기타유통업");
        industryCodeHashMap.put(4201, "공무원연금");
        industryCodeHashMap.put(4202, "공공기관");
        industryCodeHashMap.put(4204, "보훈연금");


        industryCodeHashMap.put(5001, "특급관광호텔");
        industryCodeHashMap.put(5101, "일반관광호텔");
        industryCodeHashMap.put(5102, "기타관광호텔");
        industryCodeHashMap.put(5104, "펜션/민박");
        industryCodeHashMap.put(5103, "기타숙박업");

        industryCodeHashMap.put(5201, "항공");
        industryCodeHashMap.put(5302, "고속/시외버스");
        industryCodeHashMap.put(5303, "철도");
        industryCodeHashMap.put(5304, "여객선");
        industryCodeHashMap.put(5305, "렌트카");
        industryCodeHashMap.put(5306, "택시");
        industryCodeHashMap.put(5399, "기타운송수단");

        industryCodeHashMap.put(5301, "관광여행");
        industryCodeHashMap.put(5401, "관광기념품");
        industryCodeHashMap.put(5402, "민예/공예/토산품");
        industryCodeHashMap.put(5403, "수입판매");
        industryCodeHashMap.put(5404, "면세점");

        industryCodeHashMap.put(6001, "스포츠용품");
        industryCodeHashMap.put(6002, "레저용품");
        industryCodeHashMap.put(6003, "총포류");
        industryCodeHashMap.put(6004, "골프장");
        industryCodeHashMap.put(6005, "골프연습장");
        industryCodeHashMap.put(6006, "테니스장");
        industryCodeHashMap.put(6007, "볼링장");
        industryCodeHashMap.put(6008, "스키장");
        industryCodeHashMap.put(6009, "수영장");
        industryCodeHashMap.put(6010, "종합스포츠센터");
        industryCodeHashMap.put(6011, "당구장");
        industryCodeHashMap.put(6012, "놀이공원");
        industryCodeHashMap.put(6013, "레포츠클럽");
        industryCodeHashMap.put(6015, "이벤트");
        industryCodeHashMap.put(6016, "외국인전용카지노");
        industryCodeHashMap.put(6021, "요가");
        industryCodeHashMap.put(6099, "기타 레저업소");

        industryCodeHashMap.put(6014, "영화관");
        industryCodeHashMap.put(6019, "곻연장/전시장");
        industryCodeHashMap.put(6020, "경기장");
        industryCodeHashMap.put(6018, "비디오방/게임방");
        industryCodeHashMap.put(6107, "사진관");
        industryCodeHashMap.put(6113, "서점");
        industryCodeHashMap.put(6201, "화랑");
        industryCodeHashMap.put(6202, "화방");
        industryCodeHashMap.put(6203, "화원");
        industryCodeHashMap.put(6204, "완구");
        industryCodeHashMap.put(6205, "애완용품");
        industryCodeHashMap.put(6206, "골동품점");
        industryCodeHashMap.put(6207, "표구");
        industryCodeHashMap.put(6208, "수족관");
        industryCodeHashMap.put(6209, "티켓판매(통신판매)");
        industryCodeHashMap.put(6210, "티켓판매(전자상거래)");
        industryCodeHashMap.put(6111, "음반");
        industryCodeHashMap.put(6112, "비디오 및 도서대여");
        industryCodeHashMap.put(6299, "문화/취미 기타");

        industryCodeHashMap.put(7001, "종합병원");
        industryCodeHashMap.put(7002, "병원");
        industryCodeHashMap.put(7003, "의원");
        industryCodeHashMap.put(7004, "건강진단센터");
        industryCodeHashMap.put(7005, "약국");
        industryCodeHashMap.put(7006, "한약방");
        industryCodeHashMap.put(7007, "동물병원");
        industryCodeHashMap.put(7008, "유사의료업");
        industryCodeHashMap.put(7009, "제약회사/의약품도매업체");
        industryCodeHashMap.put(7010, "산후조리원");
        industryCodeHashMap.put(7107, "의료용품");
        industryCodeHashMap.put(7099, "제약/의료 기타");

        industryCodeHashMap.put(7101, "이용원");
        industryCodeHashMap.put(7102, "미용원");
        industryCodeHashMap.put(7103, "피부미용원");
        industryCodeHashMap.put(7105, "찜질방/목욕탕");
        industryCodeHashMap.put(7106, "화장품점");
        industryCodeHashMap.put(7108, "미용재료");
        industryCodeHashMap.put(7199, "미용 기타");

        industryCodeHashMap.put(8107, "초중고등학교");
        industryCodeHashMap.put(8108, "대학,대학원");
        industryCodeHashMap.put(8115, "등록금");
        industryCodeHashMap.put(8116, "학교 납입금");
        industryCodeHashMap.put(8109, "유치원/어린이집/놀이방");
        industryCodeHashMap.put(8110, "유아교육/놀이시설");
        industryCodeHashMap.put(8101, "학원");
        industryCodeHashMap.put(8102, "학원");
        industryCodeHashMap.put(8106, "학원");
        industryCodeHashMap.put(8112, "외국어학원");
        industryCodeHashMap.put(8113, "자동차학원");
        industryCodeHashMap.put(8114, "문화센터");
        industryCodeHashMap.put(8111, "독서실");
        industryCodeHashMap.put(8199, "학원");

        industryCodeHashMap.put(6114, "문방구");
        industryCodeHashMap.put(6115, "교육기자재");
        industryCodeHashMap.put(6116, "학습지");
        industryCodeHashMap.put(6105, "과학기자재");
        industryCodeHashMap.put(6199, "기타 학습지재");
        industryCodeHashMap.put(8001, "생명보험");
        industryCodeHashMap.put(8002, "손해보험");
        industryCodeHashMap.put(8099, "기타 보험");
        industryCodeHashMap.put(8201, "용역");
        industryCodeHashMap.put(8216, "유학원");
        industryCodeHashMap.put(8202, "인쇄 및 광고");
        industryCodeHashMap.put(8203, "기계 및 장비임대업");
        industryCodeHashMap.put(8204, "보관 및 창고업");
        industryCodeHashMap.put(8205, "화물운송업");
        industryCodeHashMap.put(8217, "시설대여업");
        industryCodeHashMap.put(8210, "부동산중개업");
        industryCodeHashMap.put(8218, "부동산임대");
        industryCodeHashMap.put(8211, "전문서비스");
        industryCodeHashMap.put(6104, "소프트웨어");
        industryCodeHashMap.put(8406, "세탁소");
        industryCodeHashMap.put(8409, "철학관");
        industryCodeHashMap.put(8299, "기타 용역");

        industryCodeHashMap.put(8301, "가정용품수리");
        industryCodeHashMap.put(8302, "사무용기기수리");
        industryCodeHashMap.put(8303, "컴퓨터 및 통신기기수리");
        industryCodeHashMap.put(8304, "열쇠/도장");
        industryCodeHashMap.put(8399, "기타 수리서비스");
        industryCodeHashMap.put(8401, "결혼식장");
        industryCodeHashMap.put(8402, "결혼서비스");
        industryCodeHashMap.put(8404, "장의서비스/제수용품");
        industryCodeHashMap.put(8206, "케이블 TV");
        industryCodeHashMap.put(8207, "인터넷이용료");
        industryCodeHashMap.put(8208, "공과금");
        industryCodeHashMap.put(8212, "전화요금");
        industryCodeHashMap.put(8213, "전기 수도");
        industryCodeHashMap.put(8215, "관리비");
        industryCodeHashMap.put(8214, "우체국");
        industryCodeHashMap.put(8219, "국세");
        industryCodeHashMap.put(8220, "지방세");
        industryCodeHashMap.put(8221, "도서가스");
        industryCodeHashMap.put(8408, "단체회비");
        industryCodeHashMap.put(8410, "기부금");
        industryCodeHashMap.put(9002, "기계류 제조/도매업");
        industryCodeHashMap.put(9003, "식품류 제조/도매업");
        industryCodeHashMap.put(9001, "기타 제조/도매업");


        industryCodeHashMap.put(9005, "후불 대중교통");
        industryCodeHashMap.put(9013, "후불 유료도로");
        industryCodeHashMap.put(9014, "후불 공항버스");
        industryCodeHashMap.put(9099, "후불 기타운송");

        industryCodeHashMap.put(9004, "구매 전용");
        industryCodeHashMap.put(9006, "후불 유통기관");
        industryCodeHashMap.put(8209, "그림책 거래업체");
        industryCodeHashMap.put(9007, "바우처(Voucher)");
        industryCodeHashMap.put(9008, "두피&소재업소 (당사 취급)");
        industryCodeHashMap.put(9009, "두피&소재업소/관리");
        industryCodeHashMap.put(9010, "바우처(가사간병)");
        industryCodeHashMap.put(9011, "아이행복도우미");
        industryCodeHashMap.put(9012, "아이행복유치원");
    }

    // 인스턴스에 접근할 수 있는 public static 메소드
    public static IndustryCode getInstance() {
        if (instance == null) {
            instance = new IndustryCode();
        }
        return instance;
    }
}
