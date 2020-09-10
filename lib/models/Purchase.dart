import 'dart:convert';

Purchase purchaseFromJson(String str) => Purchase.fromJson(json.decode(str));
String purchaseToJson(Purchase data) => json.encode(data.toJson());

class Purchase {
  String id;
  List<String> types;
  String author;
  double value;
  String description;
  String date;

  Purchase(
      {this.id,
      this.types,
      this.author,
      this.value,
      this.description,
      this.date});

  factory Purchase.newObject() => Purchase(
        id: "",
        types: List<String>(),
        author: "",
        value: 0.00,
        description: "",
      );

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
        id: json["id"],
        types: List<String>.from(json["types"]?.map((x) => x) ?? []),
        author: json["author"],
        value: json["value"].toDouble(),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "types": List<dynamic>.from(types.map((x) => x)),
        "author": author,
        "value": value.toDouble(),
        "description": description,
      };
}
