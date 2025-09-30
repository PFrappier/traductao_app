import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traductao_app/providers/navbar_provider.dart';
import 'package:traductao_app/bloc/vocabulary_cubit.dart';
import 'package:traductao_app/router/go_router.dart';
import 'package:traductao_app/theme/andalusian_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ChangeNotifierProvider<NavBarProvider>(
          create: (context) => NavBarProvider(),
        ),
        BlocProvider<VocabularyCubit>(
          create: (context) => VocabularyCubit(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Traductao',
        debugShowCheckedModeBanner: false,
        theme: AndalusianTheme.lightTheme,
        darkTheme: AndalusianTheme.darkTheme,
        routerConfig: router,
      ),
    );
  }
}
