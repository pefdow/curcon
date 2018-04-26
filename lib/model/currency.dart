class Currency {
  String currency;
  String code;
  int crypto;
  double amount;
  double changePercent;
  double conversion;
  bool onWatch;

  Currency({
    this.currency,
    this.code,
    this.crypto,
    this.amount,
    this.changePercent,
    this.conversion,
    this.onWatch
  });

  @override
  String toString() {
    return "${this.code} - ${this.currency}";
  }

  Currency.fromDbJson(Map json)
    : currency = json["name"],
    code = json["code"],
    amount = 0.0,
    changePercent = 0.0,
    conversion = 0.0,
    crypto = json["crypto"],
    onWatch = json["watch"] == 1 ? true : false;

  Map<String, dynamic> toDbMap() {
    var map = Map<String, dynamic>();
    map['code'] = code;
    map['name'] = currency;
    map['crypto'] = crypto;
    map['watch'] = onWatch;
    return map;
  }

}