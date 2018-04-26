import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../model/currency.dart';
import '../services/currency_service.dart';
import '../services/global_state.dart';
import '../utils/theme.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  CurrencyService _currencyService;

  List<Currency> currentCurrencies = [];
  List<Currency> queriedCurrencies = [];
  bool loading = false;
  bool isSearching = false;
  bool didListChange = false;

  GlobalState _globalState = GlobalState.instance;
  final PublishSubject subject = new PublishSubject<String>();

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    subject.stream.debounce(new Duration(milliseconds: 400 )).listen(_searchCurrencies);
    _currencyService = CurrencyService.instance;
    _getWatchedCurrencies();
  }

  void _getWatchedCurrencies() async {
    setState(() {
      loading = true;      
    });
    List<Currency> currencies = await _currencyService.getCurrentCurrencies();
    setState(() {
      currentCurrencies = currencies;
      loading = false;      
    });
  }

  Future _searchCurrencies(dynamic query) async {
    _resetCurrencies();
    if(query.isEmpty){
      _getWatchedCurrencies();
      setState(() {
        isSearching = false;
      });
    } else {
      setState(() {
        loading = true;
        isSearching = true;
      });

      List assests = await _currencyService.getAllAssests();
      if (assests.length > 0) {
        assests.forEach((item){
          if ( item['code'].contains(query) || item['currency'].contains(query) ) {
            if ( !inWatchlist(item['code']) && !inQuerylist(item['code']) ) {
              setState(() {
                queriedCurrencies.add(new Currency(
                  currency: item['currency'],
                  code: item['code'],
                  changePercent: 0.0,
                  amount: 0.0,
                  conversion: 0.0,
                  onWatch: false,
                  crypto: item['crypto'],
                ));                  
              });
            }
          }
        });
        setState(() {
          loading = false;
        });
      }

    }
  }

  void _resetCurrencies() {
    setState(() {
      currentCurrencies.clear();
      queriedCurrencies.clear();
    });
  }

  void _searchTermUpdated(String text) {
    subject.add(text);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _completeRequest,
      child: new Scaffold(
        backgroundColor: AppTheme.searchBg,
        appBar: new AppBar(
          elevation: 2.5,
          iconTheme: AppTheme.iconThemeData,
          backgroundColor: AppTheme.searchBg,
          title: new TextField(
            onChanged: _searchTermUpdated,
            decoration: new InputDecoration(
              hintText: "Search for currency",
              suffixIcon: new Icon(Icons.mic),
              border: new UnderlineInputBorder(
                borderSide: new BorderSide(
                  color: AppTheme.searchBg
                )
              )
            ),
          ),
        ),
        body: loading ? new Center(
          child: new CircularProgressIndicator(),
        ) : _displayCurrencyList(),
      ),
    );
  }

  Future<bool> _completeRequest() {
    if (didListChange) {
      _globalState.set("didListChange", didListChange);
    }
    return new Future.value(true);
  }

  Widget _displayCurrencyList() {
    return isSearching ? 
      _displaySectionList("Results", queriedCurrencies) :
      _displayCompoundWatchList();
  }

  Widget _displayCompoundWatchList() {
    if (currentCurrencies.length == 0) {
      return new Center(
        child: new Text("Type above to begin your search")
      );
    } else {
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: _displaySectionList("Crypto Currencies", currentCurrencies.where(isCrypto).toList())
          ),
          new Container(
            height: 1.0,
            width: double.infinity,
            color: AppTheme.greyColor5
          ),
          new Expanded(
            child: _displaySectionList("Regular", currentCurrencies.where(isRegular).toList())
          )
        ],
      );
    }
  }

  Widget _displaySectionList(String title, List<Currency> dataList) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text("$title", style: AppTheme.currencySearchLabel,),
        ),
        new Expanded(
          child: new ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index){
              Currency rowcurrency = dataList[index];
              return _generateListTile(rowcurrency);
            },
          ),
        )
      ],
    );
  }

  Widget _generateListTile(Currency currency) {
    return new ListTile(
      leading: new Text(currency.code, style: AppTheme.currencyListCode,),
      title: new Text(currency.currency, style: AppTheme.currencyListTitle,),
      trailing: new Checkbox(
        value: currency.onWatch,
        onChanged: (bool val){
          setState(() {
            currency.onWatch = val;
            if (val) {
              currentCurrencies.add(currency);
              _currencyService.addToWatchlist(currency);
            } else {
              currentCurrencies.remove(currency);
              _currencyService.removeFromWatchlist(currency);
            }
            didListChange = true;                     
          });
        },
        activeColor: AppTheme.appOrange,
      )
    );
  }

  bool isCrypto(Currency currency) => currency.crypto == 1;

  bool isRegular(Currency currency) => currency.crypto == 0;

  bool inWatchlist(String code) {
    return currentCurrencies.any((cur){
      return cur.code == code;
    });
  }

  bool inQuerylist(String code) {
    return queriedCurrencies.any((cur){
      return cur.code == code;
    });
  }

}