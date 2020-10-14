import 'package:ourapp_canada/Purchases/models/Purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClass {
  Future<void> setLastPurchase(Purchase purchase) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('myLastPurchase', purchaseToJson(purchase));
  }

  Future<Purchase> getLastPurchase() async {
    return await _readLastPurchase();
  }

  Future<Purchase> _readLastPurchase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var purchaseJson = prefs.getString('myLastPurchase') ?? null;
    if (purchaseJson != null) {
      Purchase purchaseObject;
      purchaseObject = purchaseFromJson(purchaseJson);
      return purchaseObject;
    } else {
      return null;
    }
  }
}
