import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../model/currency.dart';
import '../services/global_state.dart';
import '../utils/theme.dart';

class CurrencySelectedRow extends StatefulWidget {

  final Currency currency;

  CurrencySelectedRow({
    @required this.currency
  });

  @override
  _CurrencySelectedRowState createState() => new _CurrencySelectedRowState();

}

class _CurrencySelectedRowState extends State<CurrencySelectedRow> {

  final TextEditingController _inputAmountCtrlr = new TextEditingController();

  GlobalState _globalState = GlobalState.instance;
  
  @override
  void initState() {
    super.initState();
    _inputAmountCtrlr.text = '${widget.currency.amount}';
    _inputAmountCtrlr.addListener(_updateCurrentAmount);
  }

  void _updateCurrentAmount(){
    double amount = double.parse(_inputAmountCtrlr.text, (error) => 0.0);
    //print('Updating... \n$amount');
    widget.currency.amount = amount;
    _globalState.set('currentAmount', amount);
  }

  @override
  void dispose() {
    super.dispose();
    _inputAmountCtrlr.removeListener(_updateCurrentAmount);
    _inputAmountCtrlr.dispose();
  }

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
                      widget.currency.code,
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
                      controller: _inputAmountCtrlr,
                      keyboardType: TextInputType.number,
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
                      '${widget.currency.currency}',
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