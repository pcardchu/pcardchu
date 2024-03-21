class CardCompany {
  // 카드사 정보
  final List _companyList = [
    {
      'name': '비씨',
      'id': '0',
      'image': 'assets/images/bc_card_logo.png',
      'cardApplication' : 'https://m.bccard.com/app/mobileweb/CustReg.do?exec=custAgreeReq',
    },
    {
      'name': '롯데',
      'id': '1',
      'image': 'assets/images/lotte_card_logo.png',
      'cardApplication' : 'https://m.bccard.com/app/mobileweb/CustReg.do?exec=custAgreeReq',
    },
    {
      'name': '현대',
      'id': '2',
      'image': 'assets/images/hyundai_card_logo.png',
    'cardApplication' : 'https://m.bccard.com/app/mobileweb/CustReg.do?exec=custAgreeReq',
    },
    {
      'name': '우리',
      'id': '3',
      'image': 'assets/images/woori_card_logo.png',
      'cardApplication' : 'https://m.bccard.com/app/mobileweb/CustReg.do?exec=custAgreeReq',
    },
    {
      'name': 'NH농협',
      'id': '4',
      'image': 'assets/images/nh_card_logo.png',
      'cardApplication' : 'https://m.bccard.com/app/mobileweb/CustReg.do?exec=custAgreeReq',
    },
    {
      'name': '하나',
      'id': '5',
      'image': 'assets/images/hana_card_logo.png',
    'cardApplication' : 'https://m.bccard.com/app/mobileweb/CustReg.do?exec=custAgreeReq',
    },
    {
      'name': 'IBK기업',
      'id': '6',
      'image': 'assets/images/ibk_card_logo.png',
      'cardApplication' : 'https://m.bccard.com/app/mobileweb/CustReg.do?exec=custAgreeReq',
    },
    {
      'name': '신한',
      'id': '7',
      'image': 'assets/images/shinhan_card_logo.png',
      'cardApplication' : 'https://m.bccard.com/app/mobileweb/CustReg.do?exec=custAgreeReq',
    },
    {
      'name': '삼성',
      'id': '8',
      'image': 'assets/images/samsung_card_logo.png',
      'cardApplication' : 'https://m.bccard.com/app/mobileweb/CustReg.do?exec=custAgreeReq',
    },

  ];

  // 카드 회사 정보 Get
  List get companyList => _companyList;
}