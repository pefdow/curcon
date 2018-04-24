import 'package:flutter/material.dart';

import '../model/currency.dart';
import '../parts/currency_row.dart';
import '../parts/currency_selected_row.dart';
import '../services/currency_service.dart';
import '../services/exchange_service.dart';
import '../utils/theme.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _currentCode = 'BTC';
  DateTime _lastUpdated;
  bool _loading = false;

  ExchangeService _exchange;
  CurrencyService _currencyService;

  List<Currency> currentCurrencies = [];

  @override
  void initState() {
    super.initState();
    _currencyService = new CurrencyService();
    _exchange = new ExchangeService();
    _getWatchedCurrencies();
    _getCurrentExchange();
  }
  
  void _updateCurrentIndex(String code) {
    setState(() {
      _currentCode = code;
    });
    _getCurrentExchange();
  }

  void _getWatchedCurrencies() {
    setState(() {
      currentCurrencies = _currencyService.getCurrentCurrency();
    });
  }

  String _currentCodes() {
    return currentCurrencies.fold('', (old, cur){
        if (cur.code != _currentCode){
          return old + cur.code + ",";
        } else {
          return old;
        }
      });
  }


  void _getCurrentExchange(){
    setState(() {
      _loading = true;
    });
    var result = _exchange.rates(_currentCode, _currentCodes());
    result.then((data){
      print('Home - ' + data.toString());
      if (data != null) {
        currentCurrencies.forEach((item){
          if (data.containsKey(item.code)) {
            setState(() {
              item.conversion = data[item.code];            
            });
          }
        });
        _lastUpdated = new DateTime.now();
      } else {
        //Todo: Alert error
      }
      setState(() {
        _loading = false;
      });
    }).catchError((){
      //Todo: Alert error
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: AppTheme.appBackground,
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: _generateCurrencyList(),
          ),
          _updateInfo()
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/search');
        },
        tooltip: 'Add currency',
        child: new Icon(Icons.add),
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF000000),
      ),
    );
  }

  Widget _generateCurrencyList() {
    if (currentCurrencies == null || currentCurrencies.length == 0) {
      return new Center(
        child: new Text("No currency added yet.", style: new TextStyle(color: Colors.white),),
      );
    }
    return new ListView.builder(
      itemCount: (currentCurrencies == null || currentCurrencies == []) ? 0 : currentCurrencies.length,
      itemBuilder: (context, index) {
        return new InkWell(
          onTap: (){
            currentCurrencies[index].code == _currentCode ? null : _updateCurrentIndex(currentCurrencies[index].code);
          },
          child: currentCurrencies[index].code == _currentCode ? 
            new CurrencySelectedRow(currency: currentCurrencies[index]) 
            : new CurrencyRow(currency: currentCurrencies[index], baseCurrency: _currentCode,),
        );
      },
    );
  }

  Widget _updateInfo() {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 32.0, 48.0, 32.0),
      child: _loading ? new CircularProgressIndicator() : new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(
            Icons.refresh,
            color: AppTheme.greyColor3,
          ),
          new Text(
            "  Last update: ${_lastUpdated != null ? _lastUpdated.toString().substring(0, 10) : 'No update'}  ",
            style: new TextStyle(color: AppTheme.greyColor3),
          )
        ],
      ),
    );
  }
}