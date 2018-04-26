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
                  onWatch: false
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
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text("${isSearching ? 'Results' : 'Currencies'}", style: AppTheme.currencySearchLabel,),
        ),
        new Expanded(
          child: new ListView.builder(
            itemCount: isSearching ? queriedCurrencies.length : currentCurrencies.length,
            itemBuilder: (context, index){
              Currency rowcurrency = isSearching ? queriedCurrencies[index] : currentCurrencies[index];
              return new ListTile(
                leading: new Text(rowcurrency.code, style: AppTheme.currencyListCode,),
                title: new Text(rowcurrency.currency, style: AppTheme.currencyListTitle,),
                trailing: new Checkbox(
                  value: rowcurrency.onWatch,
                  onChanged: (bool val){
                    setState(() {
                      rowcurrency.onWatch = val;
                      if (val) {
                        currentCurrencies.add(rowcurrency);
                        _currencyService.addToWatchlist(rowcurrency);
                      } else {
                        currentCurrencies.remove(rowcurrency);
                        _currencyService.removeFromWatchlist(rowcurrency);
                      }
                      didListChange = true;                     
                    });
                  },
                  activeColor: AppTheme.appOrange,
                )
              );
            },
          ),
        )
      ],
    );
  }

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