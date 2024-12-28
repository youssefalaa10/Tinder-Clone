import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder/Features/Home/UI/widgets/home_screen.dart';

import 'Features/Home/Logic/card_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
        title: 'Tinder Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70),
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 8,
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              minimumSize: const Size.square(80),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
