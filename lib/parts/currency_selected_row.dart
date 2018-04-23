import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../model/currency.dart';
import '../utils/theme.dart';

class CurrencySelectedRow extends StatelessWidget {

  final Currency currency;

  CurrencySelectedRow({
    @required this.currency
  });

  @override
  Widget build(BuildContext context) {
    return new Container (
      decoration: new BoxDecoration(
        color: const Color(0xFFF3F3F3)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: new BorderRadius.circular(8.0),
                      border: new Border.all(color: AppTheme.greyColor2)
                    ),
                    child: new Text(
                      currency.code,
                      style: AppTheme.currencySelected,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    constraints: BoxConstraints.loose(new Size(MediaQuery.of(context).size.width - 110.0, 50.0)),
                    child: new TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: '${currency.amount}',
                      style: AppTheme.currencySelected,
                      decoration: new InputDecoration(
                        border: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                            color: AppTheme.greyColor2
                          )
                        )
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: new Text(
                      '${currency.currency}',
                      style: AppTheme.currencyConversionSelected,
                    ),
                  ),
                  new Container(
                    height: 8.0,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}