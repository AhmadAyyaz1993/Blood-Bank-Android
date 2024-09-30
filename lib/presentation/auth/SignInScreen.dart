import 'package:BloodBank/core/util/validator.dart';
import 'package:BloodBank/di/injectable_config.dart';
import 'package:BloodBank/domain/entities/SignInEntity.dart';
import 'package:BloodBank/presentation/auth/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';


class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInView> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final signInController = getIt<AuthController>();
  final SignInEntity signInEntity = SignInEntity(email: '', password: '');
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    signInController.checkUserLoginStatus(context);
    return Scaffold(
        backgroundColor: Colors.redAccent,
        body: Form(
          key: signInController.formKey,
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
                              "Login",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.06),
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              return Validator.validateEmail(value ?? "");
                            },
                            onChanged: (value) {
                              signInEntity.email = value;
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
                            obscureText: _showPassword,
                            controller: passwordController,
                            validator: (value) => Validator.validatePassword(value ?? ""),
                            onChanged: (value) => signInEntity.password = value,
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
                          SizedBox(height: size.height * 0.04),
                          Row(
                            children: [
                              Expanded(
                                child: Obx(() => ElevatedButton(
                                  onPressed: signInController.isLoading.value ? null : () {
                                    signInController.loginUser(context,signInEntity);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                                  child: const Text(
                                    "Login",
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
                                if (signInController.isLoading.value) {
                                  return CircularProgressIndicator();
                                } else if (signInController.errorMessage.isNotEmpty) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              signInController.errorMessage
                                                  .toString()),
                                          backgroundColor: Colors.red.shade300,
                                        ));
                                    signInController.errorMessage.value = '';
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
                                    context.go('/signup');
                                  },
                                  child: const Text(
                                    "Become a donor!",
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