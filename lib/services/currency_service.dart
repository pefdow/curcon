import '../model/currency.dart';

class CurrencyService {

  CurrencyService();

  List<Currency> getCurrentCurrency() {
    return [
      new Currency(
        currency: "Bitcoin",
        code: "BTC",
        amount: 0.892838,
        changePercent: 0.0,
        conversion: 1.0
      ),
      new Currency(
        currency: "Etherium",
        code: "ETH",
        amount: 0.182918,
        changePercent: 4.12,
        conversion: 0.195422
      ),
      new Currency(
        currency: "Euro",
        code: "EUR",
        amount: 2346.12,
        changePercent: -1.12,
        conversion: 2592.92
      ),
      new Currency(
        currency: "US Dollar",
        code: "USD",
        amount: 3452.87,
        changePercent: 0.37,
        conversion: 3820.77
      ),
      new Currency(
        currency: "British Pound",
        code: "GBP",
        amount: 1945.23,
        changePercent: -0.72,
        conversion: 2139.37
      ),
    ];

  }

}