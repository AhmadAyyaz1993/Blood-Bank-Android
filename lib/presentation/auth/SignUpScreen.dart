import 'package:BloodBank/core/util/validator.dart';
import 'package:BloodBank/di/injectable_config.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:BloodBank/domain/entities/SignUpEntity.dart';
import 'package:BloodBank/presentation/auth/AuthController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:go_router/go_router.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confimPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final signUpController = getIt<AuthController>();
  final SignUpEntity signUpEntity = SignUpEntity(email: '', password: '', name: '', country: 'Pakistan', city: '', bloodGroup: '', phoneNumber: '', repeatedPassword: '');
  bool _showPassword = false;
  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  String selectedBloodGroup = 'A+';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    signUpController.checkUserLoginStatus(context);
    return Scaffold(
        backgroundColor: Colors.redAccent,
        body: Form(
          key: signUpController.formKey,
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
                              "Become a donor now!",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          TextFormField(
                            controller: emailController,
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
                          SizedBox(height: size.height * 0.03),
                          TextFormField(
                            controller: nameController,
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
                            obscureText: _showPassword,
                            controller: passwordController,
                            validator: (value) => Validator.validatePassword(value ?? ""),
                            onChanged: (value) => signUpEntity.password = value,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(
                                          () => _showPassword = !_showPassword);
                                },
                                child: Icon(
                                  _showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: "Password",
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          TextFormField(
                            obscureText: _showPassword,
                            controller: confimPasswordController,
                            validator: (value) => Validator.validatePassword(value ?? ""),
                            onChanged: (value) => signUpEntity.repeatedPassword = value,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(
                                          () => _showPassword = !_showPassword);
                                },
                                child: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: "Confirm password",
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.04),
                          Row(

                            children: [
                              Expanded(
                                child: Obx(() => ElevatedButton(
                                  onPressed: signUpController.isLoading.value ? null : () {
                                    signUpController.registerUser(context,signUpEntity);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                                  child: const Text(
                                    "Register",
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
                                  if (signUpController.isLoading.value) {
                                    return CircularProgressIndicator();
                                  } else if (signUpController.errorMessage.isNotEmpty) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                signUpController.errorMessage
                                                    .toString()),
                                            backgroundColor: Colors.red.shade300,
                                          ));
                                      signUpController.errorMessage.value = '';
                                    });
                                    return Container();
                                  } else {
                                    return Container();
                                  }
                                }),
                              ]
                          ),
                          SizedBox(height: size.height * 0.01),
                          Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "OR",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton( // Use TextButton for different visual style
                                onPressed: () {
                                  // Navigate to signup page
                                  context.go('/login');
                                },
                                child: const Text(
                                  "Already a donor? Login.",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ],
                            ),
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