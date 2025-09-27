import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traductao_app/providers/navbar_provider.dart';
import 'package:traductao_app/router/go_router.dart';
import 'package:traductao_app/themes/andalusian_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavBarProvider>(
          create: (context) => NavBarProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Traductao',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // ),
        theme: ThemeData(colorScheme: AndalusianTheme.lightColorScheme),
        darkTheme: ThemeData(colorScheme: AndalusianTheme.darkColorScheme),
        routerConfig: router,
      ),
    );
  }
}
