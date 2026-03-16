import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Universal Music Group',
      themeMode: _themeMode,

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        textTheme: GoogleFonts.jersey20TextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),

      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        textTheme: GoogleFonts.jersey20TextTheme(
          ThemeData(brightness: Brightness.light).textTheme,
        ).apply(bodyColor: Colors.black87, displayColor: Colors.black87),
      ),

      home: supabase.auth.currentSession != null
          ? HomePage(onToggleTheme: toggleTheme, themeMode: _themeMode)
          : LoginPage(onToggleTheme: toggleTheme, themeMode: _themeMode),
    );
  }
}
