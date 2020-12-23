// import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ourapp_canada/CuentasFijas/models/CuentasFijas.dart';

import '../../RestResponse.dart';

class CuentasFijasBloc {
  // @override
  // void dispose() {}

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

// Get All Main Cuentas
  Future<List<CuentaFija>> getAllMains() async {
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
      id: "1",
      name: "Alquiler Casa",
      value: 450,
      icon: FontAwesomeIcons.home,
      dayOfPayment: 1,
    ));
    list.add(new CuentaFija(
      id: "2",
      name: "Luz",
      value: 85.40,
      icon: FontAwesomeIcons.lightbulb,
      dayOfPayment: 1,
    ));
    list.add(new CuentaFija(
      id: "3",
      name: "Agua",
      value: 52.07,
      icon: FontAwesomeIcons.water,
      dayOfPayment: 1,
    ));
    list.add(new CuentaFija(
      id: "4",
      name: "Internet",
      value: 140,
      icon: FontAwesomeIcons.laptop,
      dayOfPayment: 1,
    ));
    return list;
  }

  Future<double> getTotalValueCuentasFijas(
      List<CuentaFija> main, List<CuentaFija> cuentasFijas) async {
    var shallowMain = new List<CuentaFija>.from(main);
    // var shallowCuentasFijas = new List<CuentaFija>.from(cuentasFijas);
    shallowMain.addAll(cuentasFijas);
    var totalAccounts = 0.00;

    await Future.forEach(
        shallowMain, (x) => {totalAccounts = totalAccounts + x.value});
    return totalAccounts;
  }
}
