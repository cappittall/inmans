import 'package:flutter/cupertino.dart';


BalanceNotifier balanceNotifier = BalanceNotifier();

class BalanceNotifier with ChangeNotifier {
  double balance;

  void updateBalance(double newBalance) {
    balance = newBalance;
    notifyListeners();
  }

}