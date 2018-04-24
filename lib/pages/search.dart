import 'package:flutter/material.dart';

import '../model/currency.dart';
import '../utils/theme.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List<Currency> currentCurrencies = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: AppTheme.searchBg,
      appBar: new AppBar(
        elevation: 2.5,
        iconTheme: AppTheme.iconThemeData,
        backgroundColor: AppTheme.searchBg,
        // leading: new IconButton(
        //   icon: new Icon(Icons.arrow_back),
        //   onPressed: (){},
        // ),
        title: new TextField(
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
        // actions: <Widget>[
        //   new IconButton(
        //     icon: new Icon(Icons.mic),
        //     onPressed: (){},
        //   )
        // ],
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text("Currencies", style: AppTheme.currencySearchLabel,),
          ),
          new Expanded(
            child: new ListView.builder(
              itemCount: currentCurrencies.length,
              itemBuilder: (context, index){
                return new ListTile(
                  leading: new Text(currentCurrencies[index].code, style: AppTheme.currencyListCode,),
                  title: new Text(currentCurrencies[index].currency, style: AppTheme.currencyListTitle,),
                  trailing: new Checkbox(
                    value: currentCurrencies[index].onWatch,
                    onChanged: (bool val){
                      setState(() {
                        currentCurrencies[index].onWatch = val;                        
                      });
                    },
                    activeColor: AppTheme.appOrange,
                  )
                );
              },
            ),
          )
        ],
      ),
    );
  }
}