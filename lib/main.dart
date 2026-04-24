import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ms_smart_test/data/services/connectivity_service.dart';
import 'package:ms_smart_test/providers/connectivity_provider.dart';
import 'package:ms_smart_test/providers/exam_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/auth_provider.dart';
import 'package:ms_smart_test/core/main_navigator.dart';
import 'ui/pages/splash_page.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  // MUAT FILE ENV
  await dotenv.load(fileName: ".env");

  setupAlice();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExamProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Inisialisasi monitoring internet
    ConnectivityService.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MainNavigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'MS Smart Test',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const SplashPage(),
      builder: (context, child) {
        final isOnline = context.watch<ConnectivityProvider>().isOnline;

        return Stack(
          children: [
            child!,
            if (!isOnline)
              Positioned.fill(
                child: Container(
                  color: Colors.black54, // Overlay gelap
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildNoInternetUI(),
                  ),
                ),
              ),
            if (kDebugMode)
              Positioned(
                right: 0,
                top: MediaQuery.of(context).size.height * 0.1,
                child: GestureDetector(
                  onTap: () => alice.showInspector(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: const Icon(Icons.bug_report, color: Colors.white, size: 40),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

Widget _buildNoInternetUI() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    child: Material( // Wajib pakai Material karena builder di luar Scaffold
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          const Text(
            "KONEKSI TERPUTUS",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 15),
          const Text(
            "Ujian memerlukan koneksi internet aktif. Periksa WiFi atau Data Seluler Anda.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          const CircularProgressIndicator(color: Colors.red),
        ],
      ),
    ),
  );
}