class CardCompany {
  // 카드사 정보
  final List _companyList = [
    {
      'name': 'BC카드',
      'id': '0',
      'image': 'assets/images/bc_card_logo.png',
      'cardApplication' : 'https://m.bccard.com/app/mobileweb/CustReg.do?exec=custAgreeReq',
    },
    {
      'name': '롯데카드',
      'id': '1',
      'image': 'assets/images/lotte_card_logo.png',
      'cardApplication' : 'https://m.lottecard.co.kr/app/LPMBRAA_V100.lc',
    },
    {
      'name': '현대카드',
      'id': '2',
      'image': 'assets/images/hyundai_card_logo.png',
    'cardApplication' : 'https://www.hyundaicard.com/cpm/mb/CPMMB0201_01.hc',
    },
    {
      'name': '우리카드',
      'id': '3',
      'image': 'assets/images/woori_card_logo.png',
      'cardApplication' : 'https://m.wooricard.com/dcmw/yh1/mmb/mmb02/M1MMB102S00.do',
    },
    {
      'name': 'NH카드',
      'id': '4',
      'image': 'assets/images/nh_card_logo.png',
      'cardApplication' : 'https://smartcard.nonghyup.com/ScCo0230I.act',
    },
    {
      'name': '하나카드',
      'id': '5',
      'image': 'assets/images/hana_card_logo.png',
    'cardApplication' : 'https://smart.hanacard.co.kr/MPAREG100M.web',
    },
    {
      'name': '산업은행카드',
      'id': '6',
      'image': 'assets/images/kdb_card_logo.png',
      'cardApplication' : 'https://m.kdb.co.kr/index.jsp',
    },
    {
      'name': '신한카드',
      'id': '7',
      'image': 'assets/images/shinhan_card_logo.png',
      'cardApplication' : 'https://www.shinhancard.com/mob/MOBFM003N/MOBFM003C01.shc',
    },
    {
      'name': '삼성카드',
      'id': '8',
      'image': 'assets/images/samsung_card_logo.png',
      'cardApplication' : 'https://www.samsungcard.com/personal/main/UHPPCO0101M0.jsp',
    },

  ];

  // 카드 회사 정보 Get
  List get companyList => _companyList;
}