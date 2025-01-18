import 'package:BloodBank/presentation/home/HomeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../BannerAdWidget.dart';
import '../../di/injectable_config.dart';
import '../../domain/entities/SignUpEntity.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    homeController.checkUserLogin(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Donors List"),
        actions: [
          IconButton(
            icon: Icon(Icons.person), // Profile icon
            onPressed: () {
              // Navigate to profile update screen
              context.go('/profile'); // Adjust the route to your profile page
            },
          ),
          IconButton(
            icon: Icon(Icons.logout), // Logout icon
            onPressed: () {
              // Show confirmation dialog before logout
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Top Banner Ad
            BannerAdWidget(adUnitId: 'ca-app-pub-8237243558098827/6268580828'),
            // Search Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  homeController.searchQuery.value = value; // Update search query
                },
                decoration: InputDecoration(
                  labelText: 'Search by Blood Group',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (homeController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (homeController.errorMessage.value.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(homeController.errorMessage.toString()),
                      backgroundColor: Colors.red.shade300,
                    ));
                    homeController.errorMessage.value = '';
                  });
                }

                // Render the filtered list of donors
                return ListView.builder(
                  itemCount: homeController.filteredDonorsList.length,
                  itemBuilder: (context, index) {
                    final donor = homeController.filteredDonorsList[index];
                    return DonorListItem(donor: donor, homeController: homeController);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
                homeController.logout(context); // Perform logout
              },
            ),
          ],
        );
      },
    );
  }
}

class DonorListItem extends StatelessWidget {
  final SignUpEntity donor;
  final HomeController homeController;

  DonorListItem({required this.donor, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Blood Group Circle
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  donor.bloodGroup,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            // Donor Details: Name, Country, City
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donor.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${donor.country}, ${donor.city ?? ''}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Last Donated: ' + (donor.lastDonatedDate?.split(' ')[0] ?? ''),
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            // Button to call
            ElevatedButton(
              onPressed: () {
                homeController.makePhoneCall(donor.phoneNumber); // Call the phone number
              },
              child: Text("Call"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Button color
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding
              ),
            ),
            // Bottom Banner Ad
            // BannerAdWidget(adUnitId: 'ca-app-pub-8237243558098827/6268580828'),
          ],
        ),
      ),
    );
  }
}
