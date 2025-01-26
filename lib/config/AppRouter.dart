import 'package:BloodBank/presentation/auth/SignInScreen.dart';
import 'package:BloodBank/presentation/auth/SignUpScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../presentation/home/HomeScreen.dart';
import '../presentation/menu/MenuScreen.dart';
import '../presentation/profile/ProfileScreen.dart';
import '../presentation/request_blood/BloodRequestsListScreen.dart';
import '../presentation/request_blood/CreateBloodRequestScreen.dart';

@singleton
class AppRouter {
  final GoRouter _router = GoRouter(
      debugLogDiagnostics: true,
      initialLocation: '/menu',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const SignInView(),
        ),
        GoRoute(
            path: '/signup',
            builder: (context, state) => const SignUpView(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
        ),
        GoRoute(
            path: '/menu',
            builder: (context, state) => Menuscreen(),
        ),
        GoRoute(
          path: '/request_blood_list',
          builder: (context, state) => BloodRequestsListScreen(),
        ),
        GoRoute(
          path: '/create_blood_request',
          builder: (context, state) => const CreateBloodRequestScreen(),
        )
      ]);

  GoRouter get router => _router;
}