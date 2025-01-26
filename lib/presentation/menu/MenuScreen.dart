import 'package:BloodBank/presentation/widgets/MenuButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';

import 'MenuScreenController.dart';


class Menuscreen extends StatelessWidget {
  final MenuScreenController menuController = Get.put(MenuScreenController());
  @override
  Widget build(BuildContext context) {
    menuController.checkUserLogin(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Bank Menu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Two buttons side by side
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            buildMenuButton(
              icon: Icons.favorite, // Icon for "Donors"
              label: 'Donors',
              onTap: () {
                context.go('/home');
              },
            ),
            buildMenuButton(
              icon: Icons.bloodtype, // Icon for "Request Blood"
              label: 'Request Blood',
              onTap: () {
                context.go('/request_blood_list');
              },
            ),
          ],
        ),
      ),
    );
  }
}
