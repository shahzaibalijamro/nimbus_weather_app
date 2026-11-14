// To parse this JSON data, do
//
//     final cityForcast = cityForcastFromJson(jsonString);

import 'dart:convert';

CityForcast cityForcastFromJson(String str) =>
    CityForcast.fromJson(json.decode(str));

String cityForcastToJson(CityForcast data) => json.encode(data.toJson());

class CityForcast {
  final List<Datum> data;
  final Meta meta;

  CityForcast({required this.data, required this.meta});

  factory CityForcast.fromJson(Map<String, dynamic> json) => CityForcast(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };
}

class Datum {
  final DateTime date;
  final String weekday;
  final double highC;
  final double lowC;
  final int rainChance;
  final Condition condition;

  Datum({
    required this.date,
    required this.weekday,
    required this.highC,
    required this.lowC,
    required this.rainChance,
    required this.condition,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    date: DateTime.parse(json["date"]),
    weekday: json["weekday"],
    highC: json["highC"]?.toDouble(),
    lowC: json["lowC"]?.toDouble(),
    rainChance: json["rainChance"],
    condition: Condition.fromJson(json["condition"]),
  );

  Map<String, dynamic> toJson() => {
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "weekday": weekday,
    "highC": highC,
    "lowC": lowC,
    "rainChance": rainChance,
    "condition": condition.toJson(),
  };
}

class Condition {
  final String code;
  final String label;
  final String icon;

  Condition({required this.code, required this.label, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) =>
      Condition(code: json["code"], label: json["label"], icon: json["icon"]);

  Map<String, dynamic> toJson() => {"code": code, "label": label, "icon": icon};
}

class Meta {
  final int days;

  Meta({required this.days});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(days: json["days"]);

  Map<String, dynamic> toJson() => {"days": days};
}
