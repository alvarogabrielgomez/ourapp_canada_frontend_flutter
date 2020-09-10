import 'dart:convert';

TypePurchase typePurchaseFromJson(String str) =>
    TypePurchase.fromJson(json.decode(str));

String typePurchaseToJson(TypePurchase data) => json.encode(data.toJson());

class TypePurchase {
  String id;
  String name;
  TypePurchase({
    this.id,
    this.name,
  });

  factory TypePurchase.fromJson(Map<String, dynamic> json) => TypePurchase(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

List<TypePurchase> getTypesOfPurchases() {
  List<TypePurchase> list = List<TypePurchase>();
  list.add(new TypePurchase(id: "1", name: "Otros"));
  list.add(new TypePurchase(id: "2", name: "Supermercado"));
  list.add(new TypePurchase(id: "3", name: "Panadería"));
  list.add(new TypePurchase(id: "4", name: "Farmacia"));
  list.add(new TypePurchase(id: "5", name: "Ropa"));
  list.add(new TypePurchase(id: "6", name: "Chucherias"));
  list.add(new TypePurchase(id: "7", name: "Servicios"));
  list.add(new TypePurchase(id: "8", name: "Compras para la casa"));
  return list;
}
