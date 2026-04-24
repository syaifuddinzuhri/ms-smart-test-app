import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  void setOnline(bool status) {
    if (_isOnline == status) return;
    _isOnline = status;
    notifyListeners();
  }
}