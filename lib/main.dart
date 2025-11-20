import 'package:easacctask/pages/login_page.dart';
import 'package:easacctask/pages/settings_page.dart';
import 'package:easacctask/pages/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginPage(),
        '/settings': (_) => SettingsPage(),
        '/webview': (_) => WebViewPage(),
      },
    );
  }
}


