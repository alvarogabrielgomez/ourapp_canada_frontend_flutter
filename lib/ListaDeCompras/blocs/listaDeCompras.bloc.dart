import 'package:ourapp_canada/ListaDeCompras/models/ItemCompras.dart';

class ListaDeComprasBloc {
  Future<List<ItemCompras>> getAllItemCompras() async {
    await Future.delayed(new Duration(seconds: 1));
    List<ItemCompras> itemsCompras = [
      new ItemCompras(
          id: 1.toString(), description: 'Test 1', value: 0.00, done: false),
      new ItemCompras(
          id: 2.toString(), description: 'Test 2', value: 0.00, done: false),
      new ItemCompras(
          id: 3.toString(), description: 'Test 3', value: 0.00, done: false),
      new ItemCompras(
          id: 4.toString(), description: 'Test 4', value: 0.00, done: false),
      new ItemCompras(
          id: 5.toString(), description: 'Test 4', value: 0.00, done: false),
      new ItemCompras(
          id: 6.toString(), description: 'Test 4', value: 0.00, done: false),
      new ItemCompras(
          id: 7.toString(), description: 'Test 4', value: 0.00, done: false),
      new ItemCompras(
          id: 8.toString(), description: 'Test 4', value: 0.00, done: false),
      new ItemCompras(
          id: 9.toString(), description: 'Test 4', value: 0.00, done: false),
      new ItemCompras(
          id: 10.toString(), description: 'Test 4', value: 0.00, done: false),
      new ItemCompras(
          id: 11.toString(), description: 'Test 4', value: 0.00, done: false),
    ];
    return itemsCompras;
  }
}
