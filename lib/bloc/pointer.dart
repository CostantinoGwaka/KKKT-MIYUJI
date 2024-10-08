import 'package:flutter/material.dart';

class AddPointerData extends ChangeNotifier {
  bool _item = false;

  bool get getitem => _item;

  void setItem(var item) {
    _item = item;
    notifyListeners();
  }

  void unsetItem() {
    _item = false;
    notifyListeners();
  }
}
