import 'package:BloodBank/domain/use_cases/CheckLoginUseCase.dart';
import 'package:BloodBank/domain/use_cases/FetchDonorsUseCase.dart';
import 'package:BloodBank/domain/use_cases/FetchProfileDataUseCase.dart';
import 'package:BloodBank/domain/use_cases/LogOutUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/util/mapper.dart';
import '../../di/injectable_config.dart';
import '../../domain/entities/SignUpEntity.dart';

class ProfileController extends GetxController {
  final CheckLoginUseCase checkLoginUseCase = getIt<CheckLoginUseCase>();
  final FetchProfileDataUseCase fetchProfileDataUseCase = getIt<FetchProfileDataUseCase>();
  final LogOutUseCase logOutUseCase = getIt<LogOutUseCase>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Rx<bool> isLoading = Rx<bool>(false); // Tracks loading state
  final Rx<String> errorMessage = Rx<String>(''); // Error message
  final Rx<String> searchQuery = ''.obs; // Holds the search query
  final Rx<SignUpEntity> userData = SignUpEntity(name: '', email: '', country: '', bloodGroup: '', city: '', phoneNumber: '', countryCode: '', p_number: '', password: '', repeatedPassword: '').obs; // Holds the sign up entity

  @override
  void onInit() async {
    super.onInit(); // Call super to ensure proper initialization
  }

  Future<void> checkUserLogin(BuildContext context) async {
    isLoading.value = true; // Indicate loading state
    errorMessage.value = ''; // Clear previous error messages
    final result = await checkLoginUseCase();
    result.fold(
          (failure) {
            // Handle login failure, possibly navigate to login screen
            context.go('/login');
          },
          (user) async {
                if (user == null) {
                  context.go('/login');
                } else {
                  fetchProfileData(context, user.email != null? user.email : "");
                }
      },
    );
    isLoading.value = false;
  }


  Future<void> fetchProfileData(BuildContext context, String? email) async {

    isLoading.value = true; // Indicate loading state
    errorMessage.value = ''; // Clear previous error messages
    final result = await fetchProfileDataUseCase(email?? ""); // Call use case

    result.fold(
          (failure) {
            errorMessage.value = mapFailureToMessage(failure); // Set error message
          },
          (profileData) {
            // Update the entire userData observable at once
            print('Profile Data: ${profileData}'); // Check the profile data being returned
            userData.value = profileData;
          }
    );
    isLoading.value = false;
  }


}
