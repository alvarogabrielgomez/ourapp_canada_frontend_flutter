import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ourapp_canada/models/Increment.dart';
import 'package:ourapp_canada/models/RestResponse.dart';

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
  DateTime date;
  DateTime updateDate;
  IconData icon;
  CuentaFija({
    this.id,
    this.name,
    this.description,
    this.value,
    this.increment,
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
        date: new DateTime(0),
      );

  factory CuentaFija.fromJson(Map<String, dynamic> json) => CuentaFija(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        value: json["value"].toDouble(),
        increment: Increment.fromJson(json["increment"]),
        date: DateTime.parse(json["date"]),
        updateDate: DateTime.parse(json["updateDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "value": value,
        "increment": increment.toJson(),
        "date": date.toIso8601String(),
        "updateDate": updateDate.toIso8601String(),
      };

//Create
  Future<RestResponse> create(CuentaFija cuentaFija) async {
    if (cuentaFija != null) {
      final httppost = await http.post('$apiEndpoint/newCuentaFija',
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: cuentaFijaToJson(cuentaFija));
      if (httppost.statusCode == 200) {
        print("Posted new cuenta fija");
        var restResponse = restResponseFromJson(httppost.body);
        restResponse.statuscode = httppost.statusCode;
        return restResponse;
      } else {
        var restResponse = restResponseFromJson(httppost.body);
        throw Exception(restResponse.message);
      }
    } else {
      throw Exception('No hay cuenta fija que guardar');
    }
  }

//Read ALL
  Future<List<CuentaFija>> getAll() async {
    final response = await http.get("$apiEndpoint/cuentasFijas");
    if (response.statusCode == 200) {
      print("fetchCuentaFija...");
      var responseJson = json.decode(response.body);

      var responseValues = responseJson["value"];
      var data =
          (responseValues as List).map((p) => CuentaFija.fromJson(p)).toList();
      return data;
    } else {
      print("Falla al cargar fetchPurchasesCurrentMonth");
      throw Exception('Falla al cargar Purchases');
    }
  }

// Read ITEM

//Update

//Delete
  Future<RestResponse> delete(CuentaFija cuentaFija) async {
    if (cuentaFija != null) {
      var idCuenta = cuentaFija.id;
      final httppost = await http.delete('$apiEndpoint/cuentasFijas/$idCuenta',
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      if (httppost.statusCode == 200) {
        print("Deleted new cuenta fija");
        var restResponse = restResponseFromJson(httppost.body);
        restResponse.statuscode = httppost.statusCode;
        print(restResponse);
        return restResponse;
      } else {
        var restResponse = restResponseFromJson(httppost.body);
        print(restResponse);
        throw Exception(restResponse.message);
      }
    } else {
      throw Exception('No hay cuenta fija que eliminar');
    }
  }

  List<CuentaFija> getMainCuentasFijas() {
    List<CuentaFija> list = List<CuentaFija>();
    list.add(new CuentaFija(
        id: "1", name: "Alquiler Casa", icon: FontAwesomeIcons.home));
    list.add(
        new CuentaFija(id: "2", name: "Luz", icon: FontAwesomeIcons.lightbulb));
    list.add(
        new CuentaFija(id: "3", name: "Agua", icon: FontAwesomeIcons.water));
    list.add(new CuentaFija(
        id: "4", name: "Internet", icon: FontAwesomeIcons.laptop));
    return list;
  }
}
