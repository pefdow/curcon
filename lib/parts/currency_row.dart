import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../model/currency.dart';
import '../utils/theme.dart';

class CurrencyRow extends StatefulWidget {

  final Currency currency;
  final String baseCurrency;

  CurrencyRow({
    @required this.currency,
    @required this.baseCurrency,
  });

  @override
  _CurrencyRowState createState() => new _CurrencyRowState();

}

class _CurrencyRowState extends State<CurrencyRow> {
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
                  widget.currency.code,
                  style: widget.currency.changePercent > 0 ? AppTheme.currencyCodePositive : widget.currency.changePercent < 0 ? AppTheme.currencyCodeNegative : AppTheme.currencyCodeNeutral,
                ),
                // new Text(
                //   '${widget.currency.changePercent}%',
                //   style: widget.currency.changePercent > 0 ? AppTheme.currencyChangePositive : widget.currency.changePercent < 0 ? AppTheme.currencyChangeNegative : AppTheme.currencyChangeNeutral,
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  '${widget.currency.amount}',
                  style: AppTheme.currencyAmount,
                  softWrap: true,
                  maxLines: 2,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: widget.baseCurrency == '' ? new Container() : new Text(
                    '${widget.currency.conversion} ${widget.currency.currency} = 1 ${widget.baseCurrency}',
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