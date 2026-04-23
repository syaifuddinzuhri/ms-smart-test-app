import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class MainNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}

Alice alice = Alice(
  configuration: AliceConfiguration(
    navigatorKey: MainNavigator.navigatorKey,         // Gunakan key yang sama dengan aplikasi
    showNotification: true,             // Munculkan notifikasi saat ada API hit
    showInspectorOnShake: true,         // Goyang HP untuk buka log
    showShareButton: true,              // Tombol share log
    notificationIcon: '@mipmap/ic_launcher', // Ikon notifikasi
  ),
);

AliceDioAdapter aliceDioAdapter = AliceDioAdapter();

void setupAlice() {
  alice.addAdapter(aliceDioAdapter);
}