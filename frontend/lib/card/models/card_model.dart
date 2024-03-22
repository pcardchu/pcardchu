class CardModel {
  // 카드 아이디
  String? cardId;

  // 카드 이미지 URL
  String? cardImage;

  // 카드 이름
  String? cardName;

  // 카드 정보
  String? cardContent;

  // 카드 혜택
  List<List<String>>? benefits;

  // 카드 신청 주소
  String? cardApplication;

  // 카드사
  String? company;

  // 태그
  List<String>? tag;

  CardModel({
    this.cardId,
    this.cardImage,
    this.cardName,
    this.cardContent,
    this.benefits,
    this.cardApplication,
    this.company,
    this.tag,
  });

  /// 객체 형태로 변환
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardId: json['cardId'],
      cardImage: json['cardImg'],
      cardName: json['cardName'],
      cardContent: json['cardContent'],
      benefits: json['benefits'] != null
          ? (json['benefits'] as List<dynamic>)
              .map((list) => List<String>.from(list))
              .toList()
          : null,
      cardApplication: json['cardApplication'],
      company: json['company'],
      tag: json['tag'] != null ? List<String>.from(json['tag']) : null,
    );
  }
}
