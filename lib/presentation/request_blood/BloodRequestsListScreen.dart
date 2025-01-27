import 'package:BloodBank/domain/entities/BloodRequestEntity.dart';
import 'package:BloodBank/presentation/home/HomeController.dart';
import 'package:BloodBank/presentation/request_blood/BloodRequestController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../BannerAdWidget.dart';
import '../../di/injectable_config.dart';
import '../../domain/entities/SignUpEntity.dart';

class BloodRequestsListScreen extends StatelessWidget {
  final BloodRequestController bloodRequestController = Get.put(BloodRequestController());


  @override
  Widget build(BuildContext context) {
    bloodRequestController.checkUserLogin(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Blood Requests"),
        actions: [
          IconButton(
            icon: Icon(Icons.home_filled), // Profile icon
            onPressed: () {
              // Navigate to profile update screen
              context.go('/menu'); // Adjust the route to your profile page
            },
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            context.go('/create_blood_request');
          },
          child: Text("Create Blood Request"),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Button color
              foregroundColor: Colors.redAccent
          ),
        ),),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Top Banner Ad
            BannerAdWidget(adUnitId: 'ca-app-pub-8237243558098827/6268580828'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  bloodRequestController.searchQuery.value = value; // Update search query
                },
                decoration: InputDecoration(
                  labelText: 'Search by Blood Group & City',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (bloodRequestController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (bloodRequestController.errorMessage.value.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(bloodRequestController.errorMessage.toString()),
                      backgroundColor: Colors.red.shade300,
                    ));
                    bloodRequestController.errorMessage.value = '';
                  });
                }

                // Render the filtered list of donors
                return ListView.builder(
                  itemCount: bloodRequestController.filteredRequestsList.length,
                  itemBuilder: (context, index) {
                    final donor = bloodRequestController.filteredRequestsList[index];
                    return DonorListItem(requestEntity: donor, bloodRequestController: bloodRequestController);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class DonorListItem extends StatelessWidget {
  final BloodRequestEntity requestEntity;
  final BloodRequestController bloodRequestController;

  DonorListItem({required this.requestEntity, required this.bloodRequestController});

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
                  requestEntity.bloodGroup,
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
                    requestEntity.patientName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${requestEntity.country}, ${requestEntity.city ?? ''}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    requestEntity.bloodQuantityRequired.toString() + ' bottle(s) of ' + requestEntity.bloodGroup + ' blood is required in ' + requestEntity.hospitalName + ' on ' + requestEntity.bloodRequiredOn.split(' ')[0]??'',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            // Button to call
            ElevatedButton(
              onPressed: () {
                bloodRequestController.makePhoneCall(requestEntity.phoneNumber); // Call the phone number
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
