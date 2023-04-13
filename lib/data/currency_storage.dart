import 'dart:convert';

import 'package:bevis/data/models/currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyStorage {
  static String _defaultCurKey = 'def_cur';

  static Future<void>saveDefaultCurrency(Currency cur) async {
    final prefs = await SharedPreferences.getInstance();
    final curStr = jsonEncode(cur.toJson());
    return prefs.setString(_defaultCurKey, curStr);
  }

  static Future<Currency>getDefaultCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    var defaultCurrency = Currency.defaultCurrency;

    final curJson  = prefs.getString(_defaultCurKey);
    if(curJson != null) {
      defaultCurrency = Currency.fromJson(jsonDecode(curJson));
    }
    return defaultCurrency;
  }
}