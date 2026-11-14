// To parse this JSON data, do
//
//     final cityWeather = cityWeatherFromJson(jsonString);

import 'dart:convert';

CityWeather cityWeatherFromJson(String str) =>
    CityWeather.fromJson(json.decode(str));

String cityWeatherToJson(CityWeather data) => json.encode(data.toJson());

class CityWeather {
  final Data data;

  CityWeather({required this.data});

  factory CityWeather.fromJson(Map<String, dynamic> json) =>
      CityWeather(data: Data.fromJson(json['data']));

  Map<String, dynamic> toJson() => {'data': data.toJson()};
}

class Data {
  final String cityId;
  final DateTime observedAt;
  final num temperatureC;
  final num feelsLikeC;
  final num humidity;
  final num windKph;
  final num pressureHpa;
  final num uvIndex;
  final Condition condition;

  Data({
    required this.cityId,
    required this.observedAt,
    required this.temperatureC,
    required this.feelsLikeC,
    required this.humidity,
    required this.windKph,
    required this.pressureHpa,
    required this.uvIndex,
    required this.condition,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    cityId: json['cityId'],
    observedAt: DateTime.parse(json['observedAt']),
    temperatureC: json['temperatureC']?.toDouble(),
    feelsLikeC: json['feelsLikeC']?.toDouble(),
    humidity: json['humidity'],
    windKph: json['windKph'],
    pressureHpa: json['pressureHpa'],
    uvIndex: json['uvIndex'],
    condition: Condition.fromJson(json['condition']),
  );

  Map<String, dynamic> toJson() => {
    'cityId': cityId,
    'observedAt': observedAt.toIso8601String(),
    'temperatureC': temperatureC,
    'feelsLikeC': feelsLikeC,
    'humidity': humidity,
    'windKph': windKph,
    'pressureHpa': pressureHpa,
    'uvIndex': uvIndex,
    'condition': condition.toJson(),
  };
}

class Condition {
  final String code;
  final String label;
  final String icon;

  Condition({required this.code, required this.label, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) =>
      Condition(code: json['code'], label: json['label'], icon: json['icon']);

  Map<String, dynamic> toJson() => {'code': code, 'label': label, 'icon': icon};
}
