import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

class ExchangeService {

  ExchangeService._();

  static ExchangeService instance = new ExchangeService._();

  Future<dynamic> rates(String base, String quotes) async {
    //print('Base: '+ base + "\nQuotes: " + quotes);
    var client = new Client();
    var response = await client.get("https://min-api.cryptocompare.com/data/price?fsym=$base&tsyms=$quotes")
                            .whenComplete(client.close)
                            .catchError((){
                              return null;
                            });
    if (response.statusCode == 200)
      return json.decode(response.body);
    else
      return null;
  }
 
}