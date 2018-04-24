class Currency {
  String currency;
  String code;
  double amount;
  double changePercent;
  double conversion;
  bool onWatch;

  Currency({
    this.currency,
    this.code,
    this.amount,
    this.changePercent,
    this.conversion
  }): onWatch = true;

}