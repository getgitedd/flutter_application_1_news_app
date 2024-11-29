import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/home_screen.dart';
import 'view/news_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NewsProvider(),
      child: const NewsApp(),
    ),
  );
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' News App',
      home: HomePage(),
    );
  }
}
