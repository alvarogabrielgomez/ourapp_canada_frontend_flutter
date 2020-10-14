import 'package:flutter/material.dart';
import 'package:ourapp_canada/Purchases/models/Purchase.dart';

class ListTilePurchase extends StatelessWidget {
  final List<Purchase> list;
  final int index;
  final Function onTap;
  ListTilePurchase(
      {@required this.list, @required this.index, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    String keyList = list[index].id;
    String _typeMain = list[index].types[0];
    String _types = list[index].types.length > 1
        ? _typeMain + " y +" + (list[index].types.length - 1).toString()
        : _typeMain;
    return Hero(
      tag: keyList,
      child: Material(
        color: Colors.white.withAlpha(80),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.0),
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: ListTile(
              onTap: onTap,
              title: Text(
                _types,
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
              subtitle: Text(
                list[index].description,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              trailing: Text(
                "R\$ " + list[index].value.toString(),
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
