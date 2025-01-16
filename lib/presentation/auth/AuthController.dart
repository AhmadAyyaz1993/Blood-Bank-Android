import 'package:BloodBank/core/util/mapper.dart';
import 'package:BloodBank/di/injectable_config.dart';
import 'package:BloodBank/domain/entities/SignInEntity.dart';
import 'package:BloodBank/domain/entities/SignUpEntity.dart';
import 'package:BloodBank/domain/use_cases/CheckLoginUseCase.dart';
import 'package:BloodBank/domain/use_cases/SignInUseCase.dart';
import 'package:BloodBank/domain/use_cases/SignUpUseCase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

class AuthController extends GetxController {
  final SignInUseCase signInUseCase = getIt<SignInUseCase>();
  final SignUpUseCase signUpUseCase = getIt<SignUpUseCase>();
  final CheckLoginUseCase checkLoginUseCase = getIt<CheckLoginUseCase>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Observables to manage UI state
  final Rx<bool> isLoading = Rx<bool>(false); // Tracks login progress
  final Rx<String> errorMessage = Rx<String>('');


  @override
  void onInit() async {

  }

  // Call this in your widget when the app starts to check login status
  Future<void> checkUserLoginStatus(BuildContext context) async {
    final result = await checkLoginUseCase();
    result.fold(
          (failure) {
        // Navigate to login page if login check fails
        context.go('/signup');
      },
          (user) {
        // Navigate to home page if login is successful
        // context.go('/home');
      },
    );
  }

  Future<void> loginUser(BuildContext context,SignInEntity signInEntity) async {

    if (formKey.currentState!.validate()) {
      isLoading.value = true; // Indicate login in progress
      errorMessage.value = ''; // Clear previous error messages

      final result = await signInUseCase(
          signInEntity); // Call use case with arguments

      result.fold(
            (failure) => errorMessage.value = mapFailureToMessage(failure),
        // Set error message
            (userCredential) {
          // Handle successful login (e.g., navigate to home screen)
          context.go('/home');
        },
      );

      isLoading.value = false; // Indicate login completion
    }
  }


  Future<void> registerUser(BuildContext context,SignUpEntity signUpEntity) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true; // Indicate login in progress
      errorMessage.value = ''; // Clear previous error messages

      final result = await signUpUseCase(
          signUpEntity); // Call use case with arguments

      result.fold(
            (failure) => errorMessage.value = mapFailureToMessage(failure),
        // Set error message
            (userCredential) {
                context.go('/home');
        },
      );

      isLoading.value = false; // Indicate login completion
    }
  }

}