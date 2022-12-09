import 'dart:convert';

import 'package:flutter_app/models/device.dart';

List<LaundrySession> laundrySessionFromJson(String str) {
  final jsonData = json.decode(str);
  return List<LaundrySession>.from(
      jsonData.map((x) => LaundrySession.fromJson(x)));
}

class LaundrySession {
  late String id;
  late String name;
  late String icon;
  late String color;
  late DateTime startedAt;
  late DateTime? finishedAt;
  late Device device;

  // constructor
  LaundrySession(
      {required this.id,
      required this.name,
      required this.icon,
      required this.color,
      required this.startedAt,
      this.finishedAt,
      required this.device});

  // create the Measurement object from json input
  LaundrySession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    color = json['color'];
    startedAt = DateTime.parse(json['startedAt']);
    if (json['finishedAt'] != null) {
      finishedAt = DateTime.parse(json['finishedAt']);
    } else {
      finishedAt = null;
    }
    device = Device.fromJson(json['device']);
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['color'] = color;
    data['startedAt'] = startedAt;
    data['finishedAt'] = finishedAt;
    data['device'] = device.toJson();
    return data;
  }
}
