class AllLoginModel {
  final LoginModel items;

  AllLoginModel({required this.items});

  factory AllLoginModel.fromJson(Map<String, dynamic> json) => AllLoginModel(
        items: LoginModel.fromJson(json['items']),
        
      );
}

class LoginModel {
  final String username;
  final String lastname;
  final String empcode;
  final String age;
  final String number;
  final String position;

  LoginModel(
      {required this.username,
      required this.lastname,
      required this.empcode,
      required this.age,
      required this.number,
      required this.position});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
      username: json['usename'],
      lastname: json['name'],
      empcode: json['empcode'],
      age: json['age'].toString(),
      number: json['number'].toString(),
      position: json['position']);
}
