import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traductao_app/screens/quiz_page.dart';
import 'package:traductao_app/screens/vocabulary_page.dart';
import 'package:traductao_app/screens/translation_groups_page.dart';
import 'package:traductao_app/widgets/no_animation_page.dart';
import 'package:traductao_app/widgets/scaffold_with_navbar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final List<GoRoute> routes = [
  GoRoute(
    name: 'My vocabulary',
    path: '/my_vocabulary',
    parentNavigatorKey: _shellNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return NoAnimationPage(child: MyVocabularyPage());
    },
  ),
  GoRoute(
    name: 'Quiz',
    path: '/quiz',
    parentNavigatorKey: _shellNavigatorKey,
    pageBuilder: (BuildContext context, GoRouterState state) {
      return NoAnimationPage(child: const QuizPage());
    },
  ),
];

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/my_vocabulary',
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return ScaffoldWithNavBar(location: state.uri.path, child: child);
      },
      routes: routes,
    ),
    GoRoute(
      name: 'TranslationGroups',
      path: '/groups/:languageId/:country',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (BuildContext context, GoRouterState state) {
        final languageId = state.pathParameters['languageId']!;
        final country = state.pathParameters['country']!;
        return MaterialPage(
          child: TranslationGroupsPage(
            country: country,
            languageId: languageId,
          ),
        );
      },
    ),
  ],
);
