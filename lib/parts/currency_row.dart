import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../model/currency.dart';
import '../utils/theme.dart';

class CurrencyRow extends StatelessWidget {

  final Currency currency;

  CurrencyRow({
    @required this.currency
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  currency.code,
                  style: currency.changePercent > 0 ? AppTheme.currencyCodePositive : currency.changePercent < 0 ? AppTheme.currencyCodeNegative : AppTheme.currencyCodeNeutral,
                ),
                new Text(
                  '${currency.changePercent}%',
                  style: currency.changePercent > 0 ? AppTheme.currencyChangePositive : currency.changePercent < 0 ? AppTheme.currencyChangeNegative : AppTheme.currencyChangeNeutral,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  '${currency.amount}',
                  style: AppTheme.currencyAmount,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: new Text(
                    '${currency.conversion} ${currency.currency} = 1 BTC',
                    style: AppTheme.currencyConversion,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}