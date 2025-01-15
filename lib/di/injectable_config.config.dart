// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:BloodBank/domain/repositories/FetchProfileRepository.dart';
import 'package:BloodBank/domain/use_cases/FetchProfileDataUseCase.dart';
import 'package:BloodBank/domain/use_cases/UpdateUserDataUseCase.dart';
import 'package:BloodBank/presentation/profile/ProfileController.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as _i12;
import 'package:firebase_auth/firebase_auth.dart' as _i13;
import 'package:firebase_core/firebase_core.dart' as _i4;
import 'package:BloodBank/config/AppRouter.dart' as _i11;
import 'package:BloodBank/core/network/network_info.dart' as _i5;
import 'package:BloodBank/di/AuthModule.dart' as _i14;
import 'package:BloodBank/domain/repositories/AuthRepository.dart'
    as _i6;
import 'package:BloodBank/domain/repositories/HomeRepository.dart'
as _i12;
import 'package:BloodBank/domain/use_cases/CheckLoginUseCase.dart'
    as _i9;
import 'package:BloodBank/domain/use_cases/SignInUseCase.dart'
    as _i7;
import 'package:BloodBank/domain/use_cases/SignUpUseCase.dart'
    as _i8;
import 'package:BloodBank/domain/use_cases/FetchDonorsUseCase.dart'
    as _i13;
import 'package:BloodBank/domain/use_cases/LogOutUseCase.dart'
as _i15;
import 'package:BloodBank/presentation/auth/AuthController.dart' as _i10;
import 'package:BloodBank/presentation/home/HomeController.dart' as _i14;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i3;


extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final authModule = _$AuthModule();
    await gh.factoryAsync<_i3.SharedPreferences>(
      () => authModule.prefs,
      preResolve: true,
    );
    gh.singletonAsync<_i4.FirebaseApp>(() => authModule.app);
    gh.singleton<_i5.NetworkInfo>(() => authModule.networkInfo);
    gh.singleton<_i6.AuthRepository>(() => authModule.authRepository);
    gh.singleton<_i12.HomeRepository>(() => authModule.homeRepository);
    gh.singleton<FetchProfileRepository>(() => authModule.fetchProfileRepository);
    gh.singleton<_i7.SignInUseCase>(() => authModule.signInUseCase);
    gh.singleton<_i8.SignUpUseCase>(() => authModule.signUpUseCase);
    gh.singleton<_i13.FetchDonorsUseCase>(() => authModule.fetchDonorsUseCase);
    gh.singleton<FetchProfileDataUseCase>(() => authModule.fetchProfileDataUseCase);
    gh.singleton<UpdateUserDataUseCase>(() => authModule.updateUserDataUseCase);
    gh.singleton<_i15.LogOutUseCase>(() => authModule.logOutUseCase);
    gh.singleton<_i9.CheckLoginUseCase>(() => authModule.checkLoginUseCase);
    gh.singleton<_i10.AuthController>(() => authModule.signInController);
    gh.singleton<_i14.HomeController>(() => authModule.homeController);
    gh.singleton<ProfileController>(() => authModule.profileController);
    gh.singleton<_i11.AppRouter>(() => _i11.AppRouter());
    gh.lazySingleton<_i12.FirebaseFirestore>(() => authModule.store);
    gh.lazySingleton<_i13.FirebaseAuth>(() => authModule.firebaseAuth);
    return this;
  }
}

class _$AuthModule extends _i14.AuthModule {}
