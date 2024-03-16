class CardModel {
  /// 카드 아이디
  String? cardId;

  /// 카드 이미지 URL
  String? cardImg;

  /// 카드 이름
  String? cardName;

  /// 카드 정보
  String? cardContent;

  CardModel({
    this.cardId,
    this.cardImg,
    this.cardName,
    this.cardContent,
  });

  /// 객체 형태로 변환
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardId: json['cardId'],
      cardImg: json['cardImg'],
      cardName: json['cardName'],
      cardContent: json['cardContent'],
    );
  }
}
