class CardInfoModel {
  int? cardId;
  String? name;
  String? cardImage;
  String? cardNumber;

  CardInfoModel({
    this.cardId,
    this.cardImage,
    this.cardNumber,
    this.name,
  });

  // JSON에서 CardInfo 객체로 변환하는 factory 생성자
  factory CardInfoModel.fromJson(Map<String, dynamic> json) {
    return CardInfoModel(
      cardId: json['cardId'],
      name: json['name'],
      cardImage: json['cardImage'],
      cardNumber: json['cardNo'],
    );
  }

  @override
  String toString() {
    return 'CardInfoModel{id: $cardId,cardImage: $cardImage, cardNumber: $cardNumber, cardName: $name}';

  }
}