class TopThreeConsumeModel {
  final String age;
  final String gender;
  final List<String> categoryList;

  TopThreeConsumeModel({
    required this.age,
    required this.gender,
    required this.categoryList,
  });


  // JSON에서 ConsumeModel 객체로 변환하는 factory 생성자
  factory TopThreeConsumeModel.fromJson(Map<String, dynamic> json) {
    List<String> categoryListFromJson = List<String>.from(json['categoryList']);

    return TopThreeConsumeModel(
      age: json['age'],
      gender: json['gender'],
      categoryList: categoryListFromJson,
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'TopThreeConsumeModel{age: $age, gender: $gender, categoryList: $categoryList';

  }
}