import 'package:BloodBank/presentation/auth/SignInScreen.dart';
import 'package:BloodBank/presentation/auth/SignUpScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../presentation/home/HomeScreen.dart';

@singleton
class AppRouter {
  final GoRouter _router = GoRouter(
      debugLogDiagnostics: true,
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => SignInView(),
        ),
        GoRoute(
            path: '/signup',
            builder: (context, state) => SignUpView(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
        )
      ]);

  GoRouter get router => _router;
}