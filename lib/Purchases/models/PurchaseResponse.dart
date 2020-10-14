// To parse this JSON data, do
//
//     final purchaseResponse = purchaseResponseFromJson(jsonString);

import 'dart:convert';

import 'package:ourapp_canada/Purchases/models/Purchase.dart';

PurchaseResponse purchaseResponseFromJson(String str) =>
    PurchaseResponse.fromJson(json.decode(str));

String purchaseResponseToJson(PurchaseResponse data) =>
    json.encode(data.toJson());

class PurchaseResponse {
  PurchaseResponse({
    this.purchases,
    this.valorTotalCompras,
    this.valorTotalSupermercado,
  });

  List<Purchase> purchases;
  double valorTotalCompras;
  double valorTotalSupermercado;

  factory PurchaseResponse.fromJson(Map<String, dynamic> json) =>
      PurchaseResponse(
        purchases: List<Purchase>.from(
            json["purchases"].map((x) => Purchase.fromJson(x))),
        valorTotalCompras: json["valorTotalCompras"].toDouble(),
        valorTotalSupermercado: json["valorTotalSupermercado"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "purchases": List<dynamic>.from(purchases.map((x) => x.toJson())),
        "valorTotalCompras": valorTotalCompras,
        "valorTotalSupermercado": valorTotalSupermercado,
      };
}

// var data =
//     (responseValues as List).map((p) => Purchase.fromJson(p)).toList();
