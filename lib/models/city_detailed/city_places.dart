// To parse this JSON data, do
//
//     final cityPlaces = cityPlacesFromJson(jsonString);

import 'dart:convert';

CityPlaces cityPlacesFromJson(String str) =>
    CityPlaces.fromJson(json.decode(str));

String cityPlacesToJson(CityPlaces data) => json.encode(data.toJson());

class CityPlaces {
  final List<Datum> data;

  CityPlaces({required this.data});

  factory CityPlaces.fromJson(Map<String, dynamic> json) => CityPlaces(
    data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  final String id;
  final String name;
  final String type;

  Datum({required this.id, required this.name, required this.type});

  factory Datum.fromJson(Map<String, dynamic> json) =>
      Datum(id: json['id'], name: json['name'], type: json['type']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'type': type};
}
