import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ourapp_canada/models/PurchaseResponse.dart';
import 'package:ourapp_canada/models/RestResponse.dart';

var apiEndpoint = DotEnv().env['API_ENDPOINT'];

Purchase purchaseFromJson(String str) => Purchase.fromJson(json.decode(str));
String purchaseToJson(Purchase data) => json.encode(data.toJson());

class Purchase {
  String id;
  String description;
  String author;
  double value;
  List<String> types;
  DateTime date;
  DateTime updateDate;

  Purchase({
    this.id,
    this.description,
    this.author,
    this.value,
    this.types,
    this.date,
    this.updateDate,
  });

  factory Purchase.newObject() => Purchase(
      id: "",
      description: "",
      author: "",
      value: 0.00,
      types: List<String>(),
      date: new DateTime.now(),
      updateDate: new DateTime.now());

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
        id: json["id"],
        description: json["description"],
        author: json["author"],
        value: json["value"].toDouble(),
        types: List<String>.from(json["types"].map((x) => x)),
        date: DateTime.parse(json["date"]),
        updateDate: DateTime.parse(json["updateDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "author": author,
        "value": value,
        "types": List<dynamic>.from(types.map((x) => x)),
        "date": date.toIso8601String(),
        "updateDate": updateDate.toIso8601String(),
      };

//Create
  Future<RestResponse> create(Purchase purchase) async {
    if (purchase != null) {
      final httppost = await http.post('$apiEndpoint/newPurchase',
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: purchaseToJson(purchase));
      if (httppost.statusCode == 200) {
        print("Posted new Purchase");
        var restResponse = restResponseFromJson(httppost.body);
        restResponse.statuscode = httppost.statusCode;
        return restResponse;
      } else {
        throw Exception('Falla al guardar purchase');
      }
    } else {
      throw Exception('No hay purchase que guardar');
    }
  }

//ReadAll Current Month
  Future<PurchaseResponse> getAllCurrentMonth() async {
    final response = await http.get("$apiEndpoint/v2/purchasesCurrentMonth");
    if (response.statusCode == 200) {
      print("fetchPurchasesCurrentMonth...");
      var responseJson = json.decode(response.body);
      var responseValues = responseJson["value"];
      var purchaseResponseObject = PurchaseResponse.fromJson(responseValues);
      return purchaseResponseObject;
    } else {
      print("Falla al cargar fetchPurchasesCurrentMonth");
      throw Exception('Falla al cargar Purchases');
    }
  }

// Read All
  Future<List<Purchase>> getAll() async {
    final response = await http.get("$apiEndpoint/purchases");
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      var responseValues = responseJson["value"];
      var data =
          (responseValues as List).map((p) => Purchase.fromJson(p)).toList();
      var test = purchaseToJson(data[0]);
      print(test);
      return data;
    } else {
      throw Exception('Falla al cargar Purchases');
    }
  }

//Update

//Delete
  Future<RestResponse> delete(Purchase purchase) async {
    if (purchase != null) {
      var idPurchase = purchase.id;
      final httppost = await http.delete('$apiEndpoint/purchases/$idPurchase',
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      if (httppost.statusCode == 200) {
        print("Deleted purchase");
        var restResponse = restResponseFromJson(httppost.body);
        restResponse.statuscode = httppost.statusCode;
        return restResponse;
      } else {
        var restResponse = restResponseFromJson(httppost.body);
        print(restResponse);
        throw Exception(restResponse.message);
      }
    } else {
      throw Exception('No hay compra que eliminar');
    }
  }
}
