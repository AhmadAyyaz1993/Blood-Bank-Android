

import 'package:BloodBank/data/repositories/FetchProfileRepositoryImpl.dart';
import 'package:BloodBank/domain/repositories/FetchProfileRepository.dart';
import 'package:BloodBank/domain/use_cases/FetchProfileDataUseCase.dart';
import 'package:BloodBank/domain/use_cases/LogOutUseCase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:BloodBank/core/network/network_info.dart';
import 'package:BloodBank/data/repositories/AuthRepositoryImpl.dart';
import 'package:BloodBank/domain/repositories/AuthRepository.dart';
import 'package:BloodBank/domain/repositories/HomeRepository.dart';
import 'package:BloodBank/domain/use_cases/CheckLoginUseCase.dart';
import 'package:BloodBank/domain/use_cases/FetchDonorsUseCase.dart';
import 'package:BloodBank/domain/use_cases/SignInUseCase.dart';
import 'package:BloodBank/domain/use_cases/SignUpUseCase.dart';
import 'package:BloodBank/presentation/home/HomeController.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/HomeRepositoryImpl.dart';
import '../presentation/auth/AuthController.dart';
import '../presentation/profile/ProfileController.dart';


@module
abstract class AuthModule {

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  Future<FirebaseApp> get app async => await Firebase.initializeApp(
  options: FirebaseOptions(
  apiKey: 'AIzaSyDDBGtR_RVrXHKul2-HBhMY8B96dtghp2M',
  appId: '1:525667575451:android:1fdd79122f1d0e6d36083e',
  messagingSenderId: '525667575451',
  projectId: 'blood-bank-21559',
  storageBucket: 'blood-bank-21559.appspot.com',
  ));

  @lazySingleton
  FirebaseFirestore get store => FirebaseFirestore.instance;

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @singleton
  NetworkInfo get networkInfo => NetworkInfoImpl();

  @singleton
  AuthRepository get authRepository => AuthRepositoryImpl(firebaseAuth, networkInfo, store);

  @singleton
  HomeRepository get homeRepository => HomeRepositoryImpl(networkInfo, store);

  @singleton
  FetchProfileRepository get fetchProfileRepository => FetchProfileRepositoryImpl(networkInfo, store);

  @singleton
  SignInUseCase get signInUseCase => SignInUseCase(authRepository);

  @singleton
  SignUpUseCase get signUpUseCase => SignUpUseCase(authRepository);

  @singleton
  FetchDonorsUseCase get fetchDonorsUseCase => FetchDonorsUseCase(homeRepository);

  @singleton
  LogOutUseCase get logOutUseCase => LogOutUseCase(authRepository);

  @singleton
  CheckLoginUseCase get checkLoginUseCase => CheckLoginUseCase(authRepository);

  @singleton
  FetchProfileDataUseCase get fetchProfileDataUseCase => FetchProfileDataUseCase(fetchProfileRepository);

  @singleton
  AuthController get signInController => AuthController();

  @singleton
  HomeController get homeController => HomeController();

  @singleton
  ProfileController get profileController => ProfileController();

}