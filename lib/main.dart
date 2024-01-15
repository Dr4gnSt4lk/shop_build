import 'package:flutter/material.dart';
import 'package:shop_build/app_navigation.dart';
import 'package:shop_build/mainwrapper.dart';
import 'package:shop_build/screens/home/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_build/screens/search/searchpage.dart';
import 'package:shop_build/screens/search/tags.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)),
      //home: const HomePage(),
      //home: const SettingsPage(),
      //home: const SearchPage(),
      //home: const TagsPage(),
      routerConfig: AppNavigation.router,
    );
  }
}
