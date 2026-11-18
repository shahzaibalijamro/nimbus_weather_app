// To parse this JSON data, do
//
//     final regions = regionsFromJson(jsonString);

import 'dart:convert';

Regions regionsFromJson(String str) => Regions.fromJson(json.decode(str));

String regionsToJson(Regions data) => json.encode(data.toJson());

class Regions {
  final List<Region> data;

  Regions({required this.data});

  factory Regions.fromJson(Map<String, dynamic> json) => Regions(
    data: List<Region>.from(json['data'].map((x) => Region.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Region {
  final String name;
  final int count;

  Region({required this.name, required this.count});

  factory Region.fromJson(Map<String, dynamic> json) =>
      Region(name: json['name'], count: json['count']);

  Map<String, dynamic> toJson() => {'name': name, 'count': count};
}
