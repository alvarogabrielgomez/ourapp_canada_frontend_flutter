import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ourapp_canada/models/Increment.dart';
import 'package:ourapp_canada/models/RestResponse.dart';

var apiEndpoint = DotEnv().env['API_ENDPOINT'];

PagoCuentaFija pagoCuentaFijaFromJson(String str) =>
    PagoCuentaFija.fromJson(json.decode(str));

String pagoCuentaFijaToJson(PagoCuentaFija data) => json.encode(data.toJson());

class PagoCuentaFija {
  String id;
  String idCuentaFija;
  double value;
  Increment increment;
  DateTime date;
  DateTime updateDate;
  PagoCuentaFija(
      {this.id,
      this.idCuentaFija,
      this.value,
      this.increment,
      this.date,
      this.updateDate});

  factory PagoCuentaFija.newObject() => PagoCuentaFija(
        id: "",
        idCuentaFija: "",
        value: 0.00,
        increment: null,
        date: new DateTime(0),
        updateDate: new DateTime(0),
      );

  factory PagoCuentaFija.fromJson(Map<String, dynamic> json) => PagoCuentaFija(
        id: json["id"],
        idCuentaFija: json["idCuentaFija"],
        value: json["value"].toDouble(),
        increment: Increment.fromJson(json["increment"]),
        date: DateTime.parse(json["date"]),
        updateDate: DateTime.parse(json["updateDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idCuentaFija": idCuentaFija,
        "value": value,
        "increment": increment.toJson(),
        "date": date.toIso8601String(),
        "updateDate": updateDate.toIso8601String(),
      };

//Create
  Future<RestResponse> create(PagoCuentaFija cuentaFija) async {
    if (cuentaFija != null) {
      final httppost = await http.post('$apiEndpoint/newPagoCuentaFija',
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: pagoCuentaFijaToJson(cuentaFija));
      if (httppost.statusCode == 200) {
        print("Posted new pago cuenta fija");
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
  Future<List<PagoCuentaFija>> getAll() async {
    final response = await http.get("$apiEndpoint/pagosCuentasFijas");
    if (response.statusCode == 200) {
      print("fetchpagosCuentasFijas...");
      var responseJson = json.decode(response.body);

      var responseValues = responseJson["value"];
      var data = (responseValues as List)
          .map((p) => PagoCuentaFija.fromJson(p))
          .toList();
      return data;
    } else {
      print("Falla al cargar fetchpagosCuentasFijas");
      throw Exception('Falla al cargar fetchpagosCuentasFijas');
    }
  }

// Read ITEM

//Update

//Delete
  Future<RestResponse> delete(PagoCuentaFija cuentaFija) async {
    if (cuentaFija != null) {
      var idCuenta = cuentaFija.id;
      final httppost = await http.delete('$apiEndpoint/cuentasFijas/$idCuenta',
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      if (httppost.statusCode == 200) {
        print("Deleted new cuenta fija");
        var restResponse = restResponseFromJson(httppost.body);
        restResponse.statuscode = httppost.statusCode;
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
}
