class User {
  late String name;
  late String email;
  late String password;

  // constructor
  User(
      {required String name, required String email, required String password}) {
    name = name;
    email = email;
    password = password;
  }

  // create the user object from json input
  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
