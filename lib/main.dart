import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pilldotrack/pages/homePage.dart';
import 'package:pilldotrack/pages/loginPage.dart';
import 'package:pilldotrack/services/DatabaseService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await DatabaseService().database;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PildoTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink.shade200,
          foregroundColor: Colors.white,
        ),
      ),
      home: LoginPage(),
    );
  }
}