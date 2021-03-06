import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';

import '../model/currency.dart';
import '../parts/currency_row.dart';
import '../parts/currency_selected_row.dart';
import '../services/currency_service.dart';
import '../services/exchange_service.dart';
import '../services/global_state.dart';
import '../utils/theme.dart';
import 'search.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final homeScaffoldKey = new GlobalKey<ScaffoldState>();

  Timer timer;
  String _currentCode = '';
  double _currentAmount = 0.0;
  DateTime _lastUpdated;
  String time = '';
  bool _loading = false;
  bool _fetching = false;

  ExchangeService _exchange;
  CurrencyService _currencyService;

  List<Currency> currentCurrencies = [];

  GlobalState _globalState = GlobalState.instance;
  StreamSubscription _stateSub;

  _HomePageState() {
    timer = new Timer.periodic(new Duration(seconds: 30), (timer){
      if (_lastUpdated != null){
        setState(() {
          time = timeAgo(_lastUpdated);        
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _currencyService = CurrencyService.instance;
    _getWatchedCurrencies();
    _exchange = ExchangeService.instance;
    _stateSub = _globalState.onStateChanged.listen((data){
      //print('global.state.currentAmount => ${data['currentAmount']}');
      if (data['currentAmount'] != null) {
        setState(() {
          _currentAmount = data['currentAmount'];        
        });
        _updateConvertedAmount();
      }
    });

  }

  @override
  void dispose() {
    _stateSub.cancel();
    super.dispose();
  }  
  
  void _updateCurrentIndex(Currency currency) {
    setState(() {
      _currentCode = currency.code;
      _currentAmount = currency.amount;
    });
    _getCurrentExchange();
  }

  void _getWatchedCurrencies([bool refreshExchange = false]) async {
    setState(() {
      _fetching = true;      
    });
    List<Currency> currencies = await _currencyService.getCurrentCurrencies();
    setState(() {
      currentCurrencies = currencies;
      _fetching = false;      
    });
    if (currentCurrencies.length > 0) {
      if  (_currentCode == '') {
        _currentCode = currentCurrencies[0].code;
        _currentAmount = 1.0; //currentCurrencies[0].amount;
        setState(() {
          currentCurrencies[0].amount = 1.0;     
        });
      }
      _getCurrentExchange();
      _getPriceInfo();
    }
    //_getPriceInfo();
    if (refreshExchange && currentCurrencies.length > 0) {
      _getCurrentExchange();
      _getPriceInfo();
    }
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
    //print('Codes - ' + _currentCodes().toString());
    var result = _exchange.rates(_currentCode, _currentCodes());
    result.then((data){
      //print('Home - ' + data.toString());
      if (data != null && data['Response'] != 'Error') {
        currentCurrencies.forEach((item){
          if (data.containsKey(item.code)) {
            setState(() {
              item.conversion = data[item.code];
              item.amount = double.parse( (_currentAmount * data[item.code]).toStringAsFixed(6) ); 
              _lastUpdated = new DateTime.now();
              time = timeAgo(_lastUpdated);
            });
          }
        });
      } else {
        _showErrorToast();
      }
      setState(() {
        _loading = false;
      });
    }).catchError((err){
      _showErrorToast();
      setState(() {
        _loading = false;
      });
    });
  }

  void _getPriceInfo() async {
    setState(() {
      _loading = true;
    });

    List prices = await _exchange.getAllCoinInfo();
    if (prices != null && prices.length > 0) {
      currentCurrencies.forEach((item){
        var price = prices.firstWhere((info){
          return info["code"] == item.code;
        }, orElse: () => null);
        if (price != null) {
          setState(() {
            item.changePercent = double.parse(price["chg1h"]) ?? double.parse(price["chg24h"]);
            _lastUpdated = new DateTime.now();
            time = timeAgo(_lastUpdated);
          });
        }
      });
    }
    setState(() {
      _loading = false;
    });
  }

  void _updateConvertedAmount(){
    currentCurrencies.forEach((item){
      setState(() {
        item.amount = double.parse( (_currentAmount * item.conversion).toStringAsFixed(6) );      
      });
    });  
  }

  void _showErrorToast() {
    homeScaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text("Error fecthing data. Please try again."),
        duration: new Duration(milliseconds: 5000),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: homeScaffoldKey,
      backgroundColor: AppTheme.appBackground,
      body: _fetching ? new Center(child: new CircularProgressIndicator()) : new Column(
        children: <Widget>[
          new Expanded(
            child: _generateCurrencyList(),
          ),
          _updateInfo()
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          //bool result = await Navigator.pushNamed(context, '/search');
          _globalState.set("didListChange", false);
          final result = await Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new SearchPage()),
          );
          if (result == result) {
            bool didListChange = _globalState.get("didListChange");
            if (didListChange != null && didListChange) {
              _getWatchedCurrencies(true);
            }
          }
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
            currentCurrencies[index].code == _currentCode ? null : _updateCurrentIndex(currentCurrencies[index]);
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
      padding: const EdgeInsets.fromLTRB(0.0, 32.0, 48.0, 32.0),
      child: _loading ? new CircularProgressIndicator() : new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(
            Icons.refresh,
            color: AppTheme.greyColor3,
          ),
          new Text(
            "  Last update: ${_lastUpdated != null ? time : 'No update'}  ",
            style: new TextStyle(color: AppTheme.greyColor3),
          )
        ],
      ),
    );
  }
}