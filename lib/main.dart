import 'package:flutter/material.dart';
import 'package:shop_build/constants.dart';
import 'package:shop_build/screens/home/homepage.dart';
import 'package:shop_build/screens/settings/settingspage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_build/screens/search/searchpage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)),
      //home: const HomePage(),
      //home: const SettingsPage(),
      home: const SearchPage(),
    );
  }
}
