import 'dart:convert';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User {
  String name;
  int gender;
  int age;
  double weight;
  double height;
  double bmi;
  double fat_percentage;
  String created_date;
  String last_updated;

  User(
      {this.name,
      this.gender,
      this.age,
      this.weight,
      this.height,
      this.bmi,
      this.fat_percentage,
      this.created_date,
      this.last_updated});

  factory User.fromJson(Map<String, dynamic> json) => new User(
        name: json["name"],
        gender: json["gender"],
        age: json["age"],
        weight: json["weight"],
        height: json["height"],
        bmi: json["bmi"],
        fat_percentage: json["fat_percentage"],
        created_date: json["created_date"],
        last_updated: json["last_updated"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "gender": gender,
        "age": age,
        "weight": weight,
        "height": height,
        "bmi": bmi,
        "fat_percentage": fat_percentage,
        "created_date": created_date,
        "last_updated": last_updated,
      };
}
