// To parse this JSON data, do
//
//     final cities = citiesFromJson(jsonString);

import 'dart:convert';

Cities citiesFromJson(String str) => Cities.fromJson(json.decode(str));

String citiesToJson(Cities data) => json.encode(data.toJson());

class Cities {
  final List<City> data;
  final Meta meta;

  Cities({required this.data, required this.meta});

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
    data: List<City>.from(json['data'].map((x) => City.fromJson(x))),
    meta: Meta.fromJson(json['meta']),
  );

  Map<String, dynamic> toJson() => {
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
    'meta': meta.toJson(),
  };
}

class City {
  final String id;
  final String name;
  final String country;
  final String region;
  final String tagline;
  final int population;
  final Weather weather;

  City({
    required this.id,
    required this.name,
    required this.country,
    required this.region,
    required this.tagline,
    required this.population,
    required this.weather,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json['id'],
    name: json['name'],
    country: json['country'],
    region: json['region'],
    tagline: json['tagline'],
    population: json['population'],
    weather: Weather.fromJson(json['weather']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'country': country,
    'region': region,
    'tagline': tagline,
    'population': population,
    'weather': weather.toJson(),
  };
}

class Weather {
  final double temperatureC;
  final Condition condition;

  Weather({required this.temperatureC, required this.condition});

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    temperatureC: json['temperatureC']?.toDouble(),
    condition: Condition.fromJson(json['condition']),
  );

  Map<String, dynamic> toJson() => {
    'temperatureC': temperatureC,
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

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json['page'],
    limit: json['limit'],
    total: json['total'],
    totalPages: json['totalPages'],
    hasNext: json['hasNext'],
    hasPrev: json['hasPrev'],
  );

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'total': total,
    'totalPages': totalPages,
    'hasNext': hasNext,
    'hasPrev': hasPrev,
  };
}
