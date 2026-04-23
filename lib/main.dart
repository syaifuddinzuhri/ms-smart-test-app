import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/auth_provider.dart';
import 'package:ms_smart_test/core/main_navigator.dart';
import 'ui/pages/splash_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // MUAT FILE ENV
  await dotenv.load(fileName: ".env");

  setupAlice();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        return Stack(
          children: [
            child!,
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