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

class ProfileController extends GetxController {
  final CheckLoginUseCase checkLoginUseCase = getIt<CheckLoginUseCase>();
  final LogOutUseCase logOutUseCase = getIt<LogOutUseCase>();

  final Rx<bool> isLoading = Rx<bool>(false); // Tracks loading state
  final Rx<String> errorMessage = Rx<String>(''); // Error message
  final Rx<String> searchQuery = ''.obs; // Holds the search query
  final RxList<SignUpEntity> filteredDonorsList = <SignUpEntity>[].obs; // Holds the filtered list

  @override
  void onInit() async {
    super.onInit(); // Call super to ensure proper initialization
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
        }
      },
    );
  }


}
