class CardInfoModel {
  final int id;
  final String cardCompanyName;
  final String cardImage;
  final String cardNumber;
  final String cardName;

  CardInfoModel({
    required this.id,
    required this.cardCompanyName,
    required this.cardImage,
    required this.cardNumber,
    required this.cardName,
  });

  // JSON에서 CardInfo 객체로 변환하는 factory 생성자
  factory CardInfoModel.fromJson(Map<String, dynamic> json) {
    return CardInfoModel(
      id: json['id'],
      cardCompanyName: json['cardCompanyName'],
      cardImage: json['cardImage'],
      cardNumber: json['cardNo'],
      cardName: json['name'],
    );
  }
}