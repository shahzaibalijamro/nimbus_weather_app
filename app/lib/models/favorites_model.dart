// To parse this JSON data, do
//
//     final favorites = favoritesFromJson(jsonString);

import 'dart:convert';

Favorites favoritesFromJson(String str) => Favorites.fromJson(json.decode(str));

String favoritesToJson(Favorites data) => json.encode(data.toJson());

class Favorites {
  final List<Favorite> data;
  final Meta meta;

  Favorites({required this.data, required this.meta});

  factory Favorites.fromJson(Map<String, dynamic> json) => Favorites(
    data: List<Favorite>.from(json['data'].map((x) => Favorite.fromJson(x))),
    meta: Meta.fromJson(json['meta']),
  );

  Map<String, dynamic> toJson() => {
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
    'meta': meta.toJson(),
  };
}

class Favorite {
  final int id;
  final String note;
  final DateTime createdAt;
  final City city;

  Favorite({
    required this.id,
    required this.note,
    required this.createdAt,
    required this.city,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
    id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
    note: json['note'] ?? '',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    city: City.fromJson(json['city'] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'city': city.toJson(),
  };
}

class City {
  final String id;
  final String name;
  final String country;
  final Weather weather;

  City({
    required this.id,
    required this.name,
    required this.country,
    required this.weather,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json['id']?.toString() ?? '',
    name: json['name'] ?? '',
    country: json['country'] ?? '',
    weather: Weather.fromJson(json['weather'] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'country': country,
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
  final int total;

  Meta({required this.total});

  factory Meta.fromJson(Map<String, dynamic> json) =>
      Meta(total: json['total']);

  Map<String, dynamic> toJson() => {'total': total};
}

class IsFavorite {
  final int? id;
  final bool value;

  IsFavorite({this.id, required this.value});
}
