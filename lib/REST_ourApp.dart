import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ourapp_canada/models/Purchase.dart';
import 'package:ourapp_canada/models/RestResponse.dart';
import 'package:ourapp_canada/models/TypePurchase.model.dart';

var apiEndpoint = DotEnv().env['API_ENDPOINT'];

Future<List<Purchase>> fetchPurchases() async {
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

Future<List<TypePurchase>> fetchTypePurchases() async {
  final response = await http.get("$apiEndpoint/typePurchases");
  if (response.statusCode == 200) {
    var responseJson = json.decode(response.body);
    var responseValues = responseJson["value"];
    print(responseValues);
    var data =
        (responseValues as List).map((p) => TypePurchase.fromJson(p)).toList();
    return data;
  } else {
    throw Exception('Falla al cargar TypePurchases');
  }
}

Future<RestResponse> newPurchase(Purchase purchase) async {
  if (purchase != null) {
    final httppost = await http.post('$apiEndpoint/newPurchase',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: purchaseToJson(purchase));
    if (httppost.statusCode == 200) {
      print("Posted new Purchase");
      var restResponse = restResponseFromJson(httppost.body);
      restResponse.statuscode = httppost.statusCode;
      print(restResponseToJson(restResponse));
      return restResponse;
    } else {
      throw Exception('Falla al guardar purchase');
    }
  } else {
    throw Exception('No hay purchase que guardar');
  }
}
