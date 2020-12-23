import 'dart:convert';

import 'package:ourapp_canada/CuentasFijas/models/Increment.dart';

ItemCompras itemComprasFromJson(String str) =>
    ItemCompras.fromJson(json.decode(str));
String itemComprasToJson(ItemCompras data) => json.encode(data.toJson());

class ItemCompras {
  String id;
  String description;
  double value;
  Increment increment;
  bool done;
  ItemCompras({
    this.id,
    this.description,
    this.value,
    this.increment,
    this.done,
  });

  factory ItemCompras.newObject() => ItemCompras(
        id: "",
        description: "",
        value: 0.00,
        increment: new Increment(sign: "", value: 0),
        done: false,
      );

  factory ItemCompras.fromJson(Map<String, dynamic> json) => ItemCompras(
        id: json["id"],
        description: json["description"],
        value: json["value"].toDouble(),
        increment: Increment.fromJson(json["increment"]),
        done: json["done"].toBoolean(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "value": value,
        "increment": increment.toJson(),
        "done": done,
        // "updateDate": updateDate.toIso8601String(),
      };
}
