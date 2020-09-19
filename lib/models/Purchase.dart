import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ourapp_canada/models/RestResponse.dart';

var apiEndpoint = DotEnv().env['API_ENDPOINT'];

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
      date: json["date"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "types": List<dynamic>.from(types.map((x) => x)),
        "author": author,
        "value": value.toDouble(),
        "description": description,
        "date": date
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
  Future<List<Purchase>> getAllCurrentMonth() async {
    final response = await http.get("$apiEndpoint/purchasesCurrentMonth");
    if (response.statusCode == 200) {
      print("fetchPurchasesCurrentMonth...");
      var responseJson = json.decode(response.body);
      var responseValues = responseJson["value"];
      var data =
          (responseValues as List).map((p) => Purchase.fromJson(p)).toList();
      var test = purchaseToJson(data[0]);
      return data;
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

}
