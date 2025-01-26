import 'package:BloodBank/core/util/validator.dart';
import 'package:BloodBank/di/injectable_config.dart';
import 'package:BloodBank/domain/entities/BloodRequestEntity.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:BloodBank/domain/entities/SignUpEntity.dart';
import 'package:BloodBank/presentation/auth/AuthController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:go_router/go_router.dart';

import 'BloodRequestController.dart';

class CreateBloodRequestScreen extends StatefulWidget {
  const CreateBloodRequestScreen({Key? key}) : super(key: key);

  @override
  State<CreateBloodRequestScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<CreateBloodRequestScreen> {
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController hospitalName = TextEditingController();
  final TextEditingController cnic = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final bloodRequestController = getIt<BloodRequestController>();
  final BloodRequestEntity signUpEntity = BloodRequestEntity(patientName: '', hospitalName: '', country: 'Pakistan', city: '', bloodGroup: '', phoneNumber: '', cnic: '');
  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  String selectedBloodGroup = 'A+';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // bloodRequestController.checkUserLoginStatus(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Blood Requests"),
          actions: [
            IconButton(
              icon: Icon(Icons.bloodtype), // Profile icon
              onPressed: () {
                // Navigate to profile update screen
                context.go('/request_blood_list'); // Adjust the route to your profile page
              },
            )
          ],
        ),
        backgroundColor: Colors.redAccent,
        body: Form(
          key: bloodRequestController.formKey,
          child: Stack(children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.85,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // SizedBox(height: size.height * 0.08),
                          const Center(
                            child: Text(
                              "Blood Request",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          TextFormField(
                            controller: patientNameController,
                            onChanged: (value) {
                              signUpEntity.patientName = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Patient Name",
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          TextFormField(
                            controller: hospitalName,
                            onChanged: (value) {
                              signUpEntity.hospitalName = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Hospital Name",
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),

                          DropdownButtonFormField<String>(
                            isExpanded: true, // Make the dropdown button expand to fill the container width
                            hint: Text('Select Blood Group'), // Add a hint text
                            // value: selectedBloodGroup,
                            validator: (value){
                              return Validator.validateBloodGroup(value ?? "");
                            },
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  signUpEntity.bloodGroup = newValue;
                                  selectedBloodGroup = newValue;
                                });
                              }
                            },
                            items: bloodGroups.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: size.height * 0.03),

                          IntlPhoneField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'PK',
                            onCountryChanged: (country) {
                              signUpEntity.country = country.name;
                            },
                            onChanged: (phone) {
                              print(phone.completeNumber);
                              signUpEntity.phoneNumber = phone.completeNumber;
                              signUpEntity.countryCode = phone.countryCode;
                              signUpEntity.p_number = phone.number;
                            },
                          ),
                          SizedBox(height: size.height * 0.01),
                          TextFormField(
                            controller: cityController,
                            onChanged: (value) {
                              signUpEntity.city = value ?? '';
                            },
                            decoration: InputDecoration(
                              hintText: "City",
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.03),

                          Row(

                            children: [
                              Expanded(
                                child: Obx(() => ElevatedButton(
                                  onPressed: bloodRequestController.isLoading.value ? null : () {
                                    bloodRequestController.createBloodRequest(context,signUpEntity);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                                  child: const Text(
                                    "Request Blood",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ),
                              ),


                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() {
                                  if (bloodRequestController.isLoading.value) {
                                    return CircularProgressIndicator();
                                  } else if (bloodRequestController.errorMessage.isNotEmpty) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                bloodRequestController.errorMessage
                                                    .toString()),
                                            backgroundColor: Colors.red.shade300,
                                          ));
                                      bloodRequestController.errorMessage.value = '';
                                    });
                                    return Container();
                                  } else {
                                    return Container();
                                  }
                                }),
                              ]
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}