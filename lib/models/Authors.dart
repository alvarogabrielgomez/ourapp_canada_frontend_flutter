import 'dart:convert';

Authors authorsFromJson(String str) => Authors.fromJson(json.decode(str));

String authorsToJson(Authors data) => json.encode(data.toJson());

class Authors {
  String id;
  String name;
  Authors({
    this.id,
    this.name,
  });

  factory Authors.fromJson(Map<String, dynamic> json) => Authors(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
