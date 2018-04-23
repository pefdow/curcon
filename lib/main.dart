import 'package:flutter/material.dart';

import 'model/currency.dart';
import 'parts/currency_row.dart';
import 'parts/currency_selected_row.dart';
import 'utils/theme.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Curcon',
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentCode = 'BTC';

  void _updateCurrentIndex(String code) {
    setState(() {
      _currentCode = code;
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
        onPressed: (){},
        tooltip: 'Add currency',
        child: new Icon(Icons.add),
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF000000),
      ),
    );
  }

  Widget _generateCurrencyList() {
    return new ListView.builder(
      itemCount: currentCurrencies.length,
      itemBuilder: (context, index) {
        return new InkWell(
          onTap: (){
            currentCurrencies[index].code == _currentCode ? null : _updateCurrentIndex(currentCurrencies[index].code);
          },
          child: currentCurrencies[index].code == _currentCode ? new CurrencySelectedRow(currency: currentCurrencies[index]) : new CurrencyRow(currency: currentCurrencies[index]),
        );
      },
    );
  }

  Widget _updateInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 32.0, 48.0, 32.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(
            Icons.refresh,
            color: AppTheme.greyColor3,
          ),
          new Text(
            "  Last update: 15 min ago  ",
            style: new TextStyle(color: AppTheme.greyColor3),
          )
        ],
      ),
    );
  }
}
