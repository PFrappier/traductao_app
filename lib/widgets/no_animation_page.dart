import 'package:go_router/go_router.dart';

class NoAnimationPage<T> extends CustomTransitionPage<T> {
  NoAnimationPage({
    required super.child,
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
}
