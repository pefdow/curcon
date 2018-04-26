import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:async';
import 'dart:io';

import '../model/currency.dart';

class CurrencyDatabase {

  static final CurrencyDatabase _instance = CurrencyDatabase._internal();
  
  factory CurrencyDatabase() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  CurrencyDatabase._internal();
  
  Future<Database> initDB() async{
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, "pdcurconz.db");
    var curDb = await openDatabase(path, version: 1, onCreate: _onCreate); 
    return curDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE currencies(code STRING PRIMARY KEY, name TEXT, crypto BIT, watch BIT)
    ''');

    print("Db currencies created.");
  }

  Future<int> addCurrency(Currency currency) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert("currencies", currency.toDbMap()); 
      print("Currency added $res");
      return res;
    } catch (e) {
      int res = await updateCurrency(currency);
      return res;
    }  
  }

  Future<int> deleteCurrency(String code) async {
    var dbClient = await db;
    var res = await dbClient.delete("currencies", where: "code = ?", whereArgs: [code]);
    print("Currency deleted $res");
    return res;
  }

  Future<int> updateCurrency(Currency currency) async {
    var dbClient = await db;
    var res = await dbClient.update("currencies", currency.toDbMap(), where: "code = ?", whereArgs: [currency.code]);
    print("Currency updated $res");
    return res;
  }

  Future<List<Currency>> getCurrencies() async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("currencies");
    print("Gotten currencies...");
    return res.map((m) => Currency.fromDbJson(m)).toList();
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }

}