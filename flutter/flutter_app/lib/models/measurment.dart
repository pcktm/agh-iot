import 'dart:convert';

List<Measurement> measurementFromJson(String str) {
  final jsonData = json.decode(str);
  return List<Measurement>.from(jsonData.map((x) => Measurement.fromJson(x)));
}

class Measurement {
  late int id;
  late int temperature;
  late int humidity;
  late DateTime createdAt;

  // constructor
  Measurement(
      {required this.id,
      required this.temperature,
      required this.humidity,
      required this.createdAt}) {}

  // create the Measurement object from json input
  Measurement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    temperature = json['temperature'];
    humidity = json['humidity'];
    createdAt = DateTime.parse(json['createdAt']);
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['temperature'] = temperature;
    data['humidity'] = humidity;
    data['createdAt'] = createdAt;
    return data;
  }
}
