import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ourapp_canada/CuentasFijas/models/Increment.dart';
import 'package:ourapp_canada/RestResponse.dart';

var apiEndpoint = DotEnv().env['API_ENDPOINT'];

CuentaFija cuentaFijaFromJson(String str) =>
    CuentaFija.fromJson(json.decode(str));

String cuentaFijaToJson(CuentaFija data) => json.encode(data.toJson());

class CuentaFija {
  String id;
  String name;
  String description;
  double value;
  Increment increment;
  int dayOfPayment;
  DateTime date;
  DateTime updateDate;
  IconData icon;
  CuentaFija({
    this.id,
    this.name,
    this.description,
    this.value,
    this.increment,
    this.dayOfPayment,
    this.date,
    this.updateDate,
    this.icon,
  });

  factory CuentaFija.newObject() => CuentaFija(
        id: "",
        name: "",
        description: "",
        value: 0.00,
        increment: new Increment(sign: "", value: 0),
        dayOfPayment: new DateTime.now().day,
        date: new DateTime.now(),
      );

  factory CuentaFija.fromJson(Map<String, dynamic> json) => CuentaFija(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        value: json["value"].toDouble(),
        increment: Increment.fromJson(json["increment"]),
        dayOfPayment: json["dayOfPayment"].toInt(),
        date: DateTime.parse(json["date"]),
        updateDate: DateTime.parse(json["updateDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "value": value,
        "increment": increment.toJson(),
        "dayOfPayment": dayOfPayment,
        "date": date.toIso8601String(),
        // "updateDate": updateDate.toIso8601String(),
      };
}
