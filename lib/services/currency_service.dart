import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import '../model/currency.dart';

class CurrencyService {

  CurrencyService._();

  static CurrencyService instance = new CurrencyService._();

  List<Currency> currencies = [];

  //ToDo:: This should be made better
  List allAssets = [];

  List<Currency> getCurrentCurrencies() {
    currencies = [
      new Currency(
        currency: "Bitcoin",
        code: "BTC",
        amount: 0.892838,
        changePercent: 0.0,
        conversion: 1.0,
        onWatch: true
      ),
      new Currency(
        currency: "Etherium",
        code: "ETH",
        amount: 0.182918,
        changePercent: 4.12,
        conversion: 0.195422,
        onWatch: true
      ),
      new Currency(
        currency: "Euro",
        code: "EUR",
        amount: 2346.12,
        changePercent: -1.12,
        conversion: 2592.92,
        onWatch: true
      ),
      new Currency(
        currency: "US Dollar",
        code: "USD",
        amount: 3452.87,
        changePercent: 0.37,
        conversion: 3820.77,
        onWatch: true
      ),
      new Currency(
        currency: "British Pound",
        code: "GBP",
        amount: 1945.23,
        changePercent: -0.72,
        conversion: 2139.37,
        onWatch: true
      ),
    ];

    return currencies;
  }

  List getAllAssests() {
    if (allAssets.length == 0) {
      fetchAssets().then((empty){
        return allAssets;
      });
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
          'is_crypto': item['type_is_crypto']
        });
      });
    }
  }

}