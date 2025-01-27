import 'package:BloodBank/core/util/validator.dart';
import 'package:BloodBank/di/injectable_config.dart';
import 'package:BloodBank/domain/entities/BloodRequestEntity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController bloodRequiredOn = TextEditingController();
  final TextEditingController bloodQuantityRequired = TextEditingController();
  final bloodRequestController = getIt<BloodRequestController>();
  final BloodRequestEntity signUpEntity = BloodRequestEntity(patientName: '', hospitalName: '', country: 'Pakistan', city: '', bloodGroup: '', phoneNumber: '', cnic: '',bloodRequiredOn: '',bloodQuantityRequired: 0);
  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  String selectedBloodGroup = 'A+';


  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        bloodRequiredOn.text = "${pickedDate.toLocal()}".split(' ')[0];
        signUpEntity.bloodRequiredOn = pickedDate.toString();
      });
    }
  }

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
          key: bloodRequestController.formKey3,
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
                          TextFormField(
                            controller: bloodQuantityRequired,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onChanged: (value) {
                              signUpEntity.bloodQuantityRequired = int.tryParse(value) ?? 0;
                            },
                            decoration: InputDecoration(
                              hintText: "Blood quantity required",
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              // Check if value is empty
                              if (value == null || value.isEmpty) {
                                return 'Please enter the required blood quantity';
                              }
                              // Check if value is a valid number and greater than 0
                              final quantity = int.tryParse(value);
                              if (quantity == null || quantity <= 0) {
                                return 'Blood quantity must be greater than 0';
                              }
                              return null; // Valid input
                            },
                          ),
                          SizedBox(height: size.height * 0.02),
                          TextFormField(
                            controller: bloodRequiredOn..text = signUpEntity.bloodRequiredOn.split(' ')[0]??'',
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            decoration: InputDecoration(
                              labelText: "Blood required on?",
                              hintText: "Select Date",
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
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