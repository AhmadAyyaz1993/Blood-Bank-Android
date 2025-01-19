import 'package:BloodBank/domain/use_cases/CheckLoginUseCase.dart';
import 'package:BloodBank/domain/use_cases/FetchDonorsUseCase.dart';
import 'package:BloodBank/domain/use_cases/LogOutUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/util/mapper.dart';
import '../../di/injectable_config.dart';
import '../../domain/entities/SignUpEntity.dart';

class HomeController extends GetxController {
  final FetchDonorsUseCase fetchDonorsUseCase = getIt<FetchDonorsUseCase>();
  final CheckLoginUseCase checkLoginUseCase = getIt<CheckLoginUseCase>();
  final LogOutUseCase logOutUseCase = getIt<LogOutUseCase>();

  final Rx<bool> isLoading = Rx<bool>(false); // Tracks loading state
  final Rx<String> errorMessage = Rx<String>(''); // Error message
  final RxList<SignUpEntity> donorsList = <SignUpEntity>[].obs; // Holds donors list
  final Rx<String> searchQuery = ''.obs; // Holds the search query
  final RxList<SignUpEntity> filteredDonorsList = <SignUpEntity>[].obs; // Holds the filtered list

  @override
  void onInit() async {
    super.onInit(); // Call super to ensure proper initialization
    // Whenever the search query changes, filter the donors list
    searchQuery.listen((query) {
      filterDonors(query);
    });
  }

  Future<void> checkUserLogin(BuildContext context) async {
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
              await fetchDonors(user.email); // Fetch donors if login is successful
            }
      },
    );
  }

  Future<void> fetchDonors(String? email) async {
    isLoading.value = true; // Indicate loading state
    errorMessage.value = ''; // Clear previous error messages

    final result = await fetchDonorsUseCase(email); // Call use case

    result.fold(
          (failure) {
        errorMessage.value = mapFailureToMessage(failure); // Set error message
      },
          (donors) {
        donorsList.assignAll(donors); // Populate the observable list
        filteredDonorsList.assignAll(donors); // Initialize filtered list with all donors
      },
    );

    isLoading.value = false; // End loading state
  }

  void filterDonors(String query) {
    if (query.isEmpty) {
      filteredDonorsList.assignAll(donorsList); // Show all donors if the query is empty
    } else {
      // Filter donors based on name or country
      filteredDonorsList.assignAll(donorsList.where((donor) {
        final bloodGroupMatch = donor.bloodGroup.toLowerCase().contains(query.toLowerCase());
        final cityMatch = donor.city?.toLowerCase().contains(query.toLowerCase()) ?? false;
        return bloodGroupMatch || cityMatch;

      }).toList());
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

  Future<void> logout(BuildContext context) async {
    isLoading.value = true; // Indicate loading state
    errorMessage.value = ''; // Clear previous error messages


    final result = await logOutUseCase(); // Call use case

    result.fold(
          (failure) {
        errorMessage.value = mapFailureToMessage(failure); // Set error message
      },
          (donors) {
            context.go('/login'); // Adjust the route to your login page
      },
    );

    isLoading.value = false;



  }
}
