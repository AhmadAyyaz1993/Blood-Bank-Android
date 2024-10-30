import 'package:BloodBank/presentation/home/HomeController.dart';
import 'package:BloodBank/presentation/profile/ProfileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/util/validator.dart';
import '../../di/injectable_config.dart';
import '../../domain/entities/SignUpEntity.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<ProfileScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confimPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController p_numberController = TextEditingController();

  final profileController = getIt<ProfileController>();
  final SignUpEntity signUpEntity = SignUpEntity(email: '', password: '', name: '', country: 'Pakistan', city: '', bloodGroup: '', phoneNumber: '', p_number: '',countryCode:'',repeatedPassword:'');
  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  String selectedBloodGroup = 'A+';

@override
void initState() {
  super.initState();
  profileController.checkUserLogin(context);
}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
//     profileController.checkUserLogin(context);
    print('Profile Screen: ${signUpEntity}');
    return Scaffold(
        backgroundColor: Colors.redAccent,
        appBar: AppBar(
            actions: [
                IconButton(
                  icon: Icon(Icons.home), // Profile icon
                  onPressed: () {
                    // Navigate to profile update screen
                    context.go('/home'); // Adjust the route to your profile page
                  },
                )
              ],
          title: Text("Profile")
        ),
        body: Form(
          key: profileController.formKey,
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
                          SizedBox(height: size.height * 0.02),
                    Obx(() =>TextFormField(
                            controller: emailController..text = profileController.userData.value.email,
                            validator: (value) {
                              return Validator.validateEmail(value ?? "");
                            },
                            onChanged: (value) {
                              signUpEntity.email = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Email",
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                    ),
                          SizedBox(height: size.height * 0.03),
                    Obx(() =>TextFormField(
                            controller: nameController..text = profileController.userData.value.name,
                            validator: (value) {
                              return Validator.validateName(value ?? "");
                            },
                            onChanged: (value) {
                              signUpEntity.name = value;
                            },
                            decoration: InputDecoration(
                              hintText: "Name",
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                    ),
                          SizedBox(height: size.height * 0.02),

                    Obx(() => DropdownButtonFormField<String>(
                          isExpanded: true, // Make the dropdown button expand to fill the container width
                          hint: Text('Select Blood Group'), // Add a hint text
                          value: bloodGroups.contains(profileController.userData.value.bloodGroup)
                              ? profileController.userData.value.bloodGroup
                              : null,
                          validator: (value) {
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
                    ),
                          SizedBox(height: size.height * 0.03),

                          // CSCPicker(
                          //   ///Enable disable state dropdown [OPTIONAL PARAMETER]
                          //   showStates: false,
                          //
                          //   /// Enable disable city drop down [OPTIONAL PARAMETER]
                          //   showCities: true,
                          //
                          //   ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                          //   flagState: CountryFlag.DISABLE,
                          //
                          //   ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                          //   dropdownDecoration: BoxDecoration(
                          //       borderRadius: BorderRadius.all(Radius.circular(10)),
                          //       color: Colors.white,
                          //       border:
                          //       Border.all(color: Colors.grey.shade300, width: 1)),
                          //
                          //   ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                          //   disabledDropdownDecoration: BoxDecoration(
                          //       borderRadius: BorderRadius.all(Radius.circular(10)),
                          //       color: Colors.grey.shade300,
                          //       border:
                          //       Border.all(color: Colors.grey.shade300, width: 1)),
                          //
                          //   ///placeholders for dropdown search field
                          //   countrySearchPlaceholder: "Country",
                          //   // stateSearchPlaceholder: "State",
                          //   citySearchPlaceholder: "City",
                          //
                          //   ///labels for dropdown
                          //   countryDropdownLabel: "Country",
                          //   // stateDropdownLabel: "State",
                          //   cityDropdownLabel: "City",
                          //
                          //   ///Default Country
                          //   defaultCountry: CscCountry.Pakistan,
                          //
                          //   ///Country Filter [OPTIONAL PARAMETER]
                          //   // countryFilter: [CscCountry.India,CscCountry.United_States,CscCountry.Canada],
                          //
                          //   ///Disable country dropdown (Note: use it with default country)
                          //   //disableCountry: true,
                          //
                          //   ///selected item style [OPTIONAL PARAMETER]
                          //   selectedItemStyle: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 14,
                          //   ),
                          //
                          //   ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                          //   dropdownHeadingStyle: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 17,
                          //       fontWeight: FontWeight.bold),
                          //
                          //   ///DropdownDialog Item style [OPTIONAL PARAMETER]
                          //   dropdownItemStyle: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 14,
                          //   ),
                          //
                          //   ///Dialog box radius [OPTIONAL PARAMETER]
                          //   dropdownDialogRadius: 10.0,
                          //
                          //   ///Search bar radius [OPTIONAL PARAMETER]
                          //   searchBarRadius: 10.0,
                          //
                          //   ///triggers once country selected in dropdown
                          //   onCountryChanged: (value) {
                          //     setState(() {
                          //       ///store value in country variable
                          //       signUpEntity.country = value;
                          //     });
                          //   },
                          //
                          //   ///triggers once state selected in dropdown
                          //   onStateChanged: (value) {
                          //     setState(() {
                          //       ///store value in state variable
                          //       // stateValue = value;
                          //     });
                          //   },
                          //
                          //   ///triggers once city selected in dropdown
                          //   onCityChanged: (value) {
                          //     setState(() {
                          //       ///store value in city variable
                          //       signUpEntity.city = value;
                          //     });
                          //   },
                          //
                          //   ///Show only specific countries using country filter
                          //   // countryFilter: ["United States", "Canada", "Mexico"],
                          // ),
                          //
                          // SizedBox(height: size.height * 0.03,),
                    // Phone Number Field with initial country and number set
                        Obx(() => IntlPhoneField(
                            controller: p_numberController..text = profileController.userData.value.p_number??'',
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: PhoneNumber.fromCompleteNumber(completeNumber: profileController.userData.value.phoneNumber??'').countryISOCode,
                            onCountryChanged: (country) {
                              signUpEntity.country = country.name;
                            },
                            onChanged: (phone) {
                              print(phone.completeNumber);
                              signUpEntity.phoneNumber = phone.completeNumber;
                              signUpEntity.countryCode = phone.countryCode;
                              signUpEntity.p_number = phone.number;
                            },
                          )
                        ),
                          SizedBox(height: size.height * 0.01),
                          Row(

                            children: [
                              Expanded(
                                child: Obx(() => ElevatedButton(
                                  onPressed: profileController.isLoading.value ? null : () {
                                    // profileController.registerUser(context,signUpEntity);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                                  child: const Text(
                                    "Update",
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
                                  if (profileController.isLoading.value) {
                                    return CircularProgressIndicator();
                                  } else if (profileController.errorMessage.isNotEmpty) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                profileController.errorMessage
                                                    .toString()),
                                            backgroundColor: Colors.red.shade300,
                                          ));
                                      profileController.errorMessage.value = '';
                                    });
                                    return Container();
                                  } else {
                                    return Container();
                                  }
                                }),
                              ]
                          ),
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