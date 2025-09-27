import 'package:flutter/material.dart';

class MyTranslationsPage extends StatelessWidget {
  final String country;

  const MyTranslationsPage({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(country), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text('Traductions pour $country')
      ),
    );
  }
}
