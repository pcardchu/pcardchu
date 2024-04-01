class TopThreePopularModel {
  final String age;
  final String gender;
  final List<String> categoryList;

  TopThreePopularModel({
    required this.age,
    required this.gender,
    required this.categoryList,
  });


  // JSON에서 ConsumeModel 객체로 변환하는 factory 생성자
  factory TopThreePopularModel.fromJson(Map<String, dynamic> json) {
    List<String> categoryListFromJson = List<String>.from(json['categoryList']);

    return TopThreePopularModel(
      age: json['age'],
      gender: json['gender'],
      categoryList: categoryListFromJson,
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}