import 'dart:convert';

List<Device> deviceFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Device>.from(jsonData.map((x) => Device.fromJson(x)));
}

class Device {
  late String name;
  late String? description;
  late String id;
  late String lastSeenOnline;

  // constructor
  Device(
      {required String id,
      required String name,
      required String? description,
      required String lastSeenOnline}) {
    id = id;
    name = name;
    description = description;
    lastSeenOnline = lastSeenOnline;
  }

  // create the Device object from json input
  Device.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    lastSeenOnline = json['lastSeenOnline'];
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['lastSeenOnline'] = lastSeenOnline;
    return data;
  }
}
