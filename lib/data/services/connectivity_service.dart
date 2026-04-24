import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ms_smart_test/core/main_navigator.dart';
import 'package:ms_smart_test/providers/connectivity_provider.dart';
import 'package:provider/provider.dart';
import '../../ui/widgets/exam/exam_sheets.dart';

class ConnectivityService {
  static bool _isSheetOpen = false;
  static StreamSubscription? _subscription;

  static void init(context) {
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isOnline = !results.contains(ConnectivityResult.none);
      // Update status di Provider
      Provider.of<ConnectivityProvider>(context, listen: false).setOnline(isOnline);
    });
  }

  static void dispose() {
    _subscription?.cancel();
  }
}