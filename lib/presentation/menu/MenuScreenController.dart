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

class MenuScreenController extends GetxController {
  final CheckLoginUseCase checkLoginUseCase = getIt<CheckLoginUseCase>();

  @override
  void onInit() async {
    super.onInit(); // Call super to ensure proper initialization
    // Whenever the search query changes, filter the donors list
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
          // Fetch donors if login is successful
        }
      },
    );
  }
}
