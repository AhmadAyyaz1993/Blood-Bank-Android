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
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/BloodRequestEntity.dart';
import '../../domain/use_cases/CreateBloodRequestUseCase.dart';
import '../../domain/use_cases/FetchBloodRequestsUseCase.dart';
import '../../domain/use_cases/FetchProfileDataUseCase.dart';

class BloodRequestController extends GetxController {
  final CreateBloodRequestUseCase createBloodRequestUseCase = getIt<CreateBloodRequestUseCase>();
  final FetchBloodRequestsUseCase fetchBloodRequestsUseCase = getIt<FetchBloodRequestsUseCase>();
  final CheckLoginUseCase checkLoginUseCase = getIt<CheckLoginUseCase>();
  final FetchProfileDataUseCase fetchProfileDataUseCase = getIt<FetchProfileDataUseCase>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Observables to manage UI state
  final Rx<bool> isLoading = Rx<bool>(false); // Tracks login progress
  final Rx<String> errorMessage = Rx<String>('');

  final RxList<BloodRequestEntity> requestsList = <BloodRequestEntity>[].obs; // Holds donors list
  final Rx<String> searchQuery = ''.obs; // Holds the search query
  final RxList<BloodRequestEntity> filteredRequestsList = <BloodRequestEntity>[].obs; // Holds the filtered list


  @override
  void onInit() async {
    searchQuery.listen((query) {
      filterBloodRequests(query);
    });
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
          fetchBloodRequests(profileData.country);
        }
    );
    isLoading.value = false;
  }


  Future<void> createBloodRequest(BuildContext context,BloodRequestEntity bloodRequestEntity) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true; // Indicate login in progress
      errorMessage.value = ''; // Clear previous error messages

      final result = await createBloodRequestUseCase(
          bloodRequestEntity); // Call use case with arguments

      result.fold(
            (failure) => errorMessage.value = mapFailureToMessage(failure),
        // Set error message
            (userCredential) {
          context.go('/request_blood_list');
        },
      );

      isLoading.value = false; // Indicate login completion
    }
  }

  // Function to make phone call
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      // Check if the URL can be launched
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri); // Use url_launcher to initiate the call
      } else {
        errorMessage.value = "Could not make the phone call"; // Log if the URL can't be launched
      }
    } catch (e) {
      errorMessage.value = "Could not make the phone call"; // Log the error
    }
  }


  Future<void> fetchBloodRequests(String country) async {
    isLoading.value = true; // Indicate loading state
    errorMessage.value = ''; // Clear previous error messages

    final result = await fetchBloodRequestsUseCase(country); // Call use case

    result.fold(
          (failure) {
        errorMessage.value = mapFailureToMessage(failure); // Set error message
      },
          (bloodRequests) {
            requestsList.assignAll(bloodRequests); // Populate the observable list
            filteredRequestsList.assignAll(bloodRequests); // Initialize filtered list with all donors
      },
    );

    isLoading.value = false; // End loading state
  }

  void filterBloodRequests(String query) {
    if (query.isEmpty) {
      filteredRequestsList.assignAll(requestsList); // Show all donors if the query is empty
    } else {
      // Filter donors based on name or country
      filteredRequestsList.assignAll(requestsList.where((bloodRequest) {
        final bloodGroupMatch = bloodRequest.bloodGroup.toLowerCase().contains(query.toLowerCase());
        final cityMatch = bloodRequest.city?.toLowerCase().contains(query.toLowerCase()) ?? false;
        return bloodGroupMatch || cityMatch;

      }).toList());
    }
  }

}