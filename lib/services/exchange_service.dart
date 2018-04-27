import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

class ExchangeService {

  ExchangeService._();

  static ExchangeService instance = new ExchangeService._();

  //ToDo:: This should be made better
  List allCoinInfo = [];

  Future<dynamic> rates(String base, String quotes) async {
    //print('Base: '+ base + "\nQuotes: " + quotes);
    var client = new Client();
    var response = await client.get("https://min-api.cryptocompare.com/data/price?fsym=$base&tsyms=$quotes")
                            .whenComplete(client.close)
                            .catchError((err){
                              return null;
                            });
    if (response.statusCode == 200)
      return json.decode(response.body);
    else
      return null;
  }

  Future<List> getAllCoinInfo() async {
    if (allCoinInfo == null || allCoinInfo.length == 0) {
      await fetchCoinInfo();
      return allCoinInfo;
    } else {
      return allCoinInfo;
    }
  }

  //ToDo:: This should be made better
  Future<Null> fetchCoinInfo() async {
    var client = new Client();
    var response = await client.get("https://api.coinmarketcap.com/v1/ticker/?limit=0")
                            .whenComplete(client.close)
                            .catchError((err){
                              return null;
                            });
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      res.forEach((item){
        allCoinInfo.add({
          "code": item['symbol'],
          "currency": item['name'],
          'chg1h': item['percent_change_1h'],
          'chg24h': item['percent_change_24h'],
          'chg7ds': item['percent_change_7d'],
        });
      });
    }
  }
 
}