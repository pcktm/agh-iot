class User {
  late String name;
  late String email;
  late String id;

  // constructor
  User({required String id, required String name, required String email}) {
    id = id;
    name = name;
    email = email;
  }

  // create the user object from json input
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
