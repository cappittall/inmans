
import 'package:flutter/material.dart';

class EarnerProvider extends ChangeNotifier {
  int currentIndex = 0;

  void incerementIndex(int i) {
    currentIndex = i;
    notifyListeners();
  }
}
