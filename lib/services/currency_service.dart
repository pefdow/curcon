import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import '../db/currency_database.dart';
import '../model/currency.dart';

class CurrencyService {

  CurrencyService._();

  static CurrencyService instance = new CurrencyService._();

  List<Currency> currencies = [];

  //ToDo:: This should be made better
  List allAssets = [];

  Future<List<Currency>> getCurrentCurrencies() async {
    CurrencyDatabase db = new CurrencyDatabase();
    currencies = await db.getCurrencies();
    return currencies;
  }

  Future<List> getAllAssests() async {
    if (allAssets.length == 0) {
      await fetchAssets();
      return allAssets;
    } else {
      return allAssets;
    }
  }

  //ToDo:: This should be made better
  Future<Null> fetchAssets() async {
    var client = new Client();
    var response = await client.get("https://rest.coinapi.io/v1/assets")
                            .whenComplete(client.close)
                            .catchError((){
                              return null;
                            });
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      res.forEach((item){
        allAssets.add({
          "code": item['asset_id'],
          "currency": item['name'],
          'crypto': item['type_is_crypto']
        });
      });
    }
  }

  void addToWatchlist(Currency currency) {
    print('To be added ${currency.toString()}');
    CurrencyDatabase db = new CurrencyDatabase();
    db.addCurrency(currency);
  }

  void removeFromWatchlist(Currency currency) {
    CurrencyDatabase db = new CurrencyDatabase();
    db.deleteCurrency(currency.code);
  }

}