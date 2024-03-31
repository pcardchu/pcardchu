class CardInfoModel {
  int? id;
  String? cardCompanyName;
  String? cardImage;
  String? cardNumber;
  String? cardName;

  CardInfoModel({
    this.id,
    this.cardCompanyName,
    this.cardImage,
    this.cardNumber,
    this.cardName,
  });

  // JSON에서 CardInfo 객체로 변환하는 factory 생성자
  factory CardInfoModel.fromJson(Map<String, dynamic> json) {
    return CardInfoModel(
      id: json['id'],
      cardCompanyName: json['cardCompanyName'],
      cardImage: json['cardImage'],
      cardNumber: json['cardNumber'],
      cardName: json['cardName'],
    );
  }

  @override
  String toString() {
    return 'CardInfoModel{id: $id, cardCompanyName: $cardCompanyName, cardImage: $cardImage, cardNumber: $cardNumber, cardName: $cardName}';
  }
}