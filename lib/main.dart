import 'package:firebase_core/firebase_core.dart';
import 'package:BloodBank/config/AppRouter.dart';
import 'package:BloodBank/config/themes/AppTheme.dart';
import 'package:flutter/material.dart';

import 'di/injectable_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyDDBGtR_RVrXHKul2-HBhMY8B96dtghp2M',
        appId: '1:525667575451:android:1fdd79122f1d0e6d36083e',
        messagingSenderId: '525667575451',
        projectId: 'blood-bank-21559',
        storageBucket: 'blood-bank-21559.appspot.com',
      ));
  await configureDependencies();
  runApp(const MyApp());
}


final _router = getIt<AppRouter>().router;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Blood Bank",
      theme:  AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: _router,

    );
  }
}


