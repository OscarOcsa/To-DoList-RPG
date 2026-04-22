import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    // ChangeNotifierProvider rende GameProvider accessibile
    // a tutti i widget nell'albero
    ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prova',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,        // tema RPG scuro
      home: const HomeScreen(),    // navigazione principale
    );
  }
}