import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:travel/config/session.dart';
import 'package:travel/config/url.dart';
import 'package:travel/utils/dimensions_utils.dart';
import 'package:travel/utils/forms_utils.dart';
import 'package:travel/utils/rgb_utils.dart';
import 'package:travel/utils/snackbar__utils.dart';
import 'package:unicons/unicons.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // form
  final _formKeyLogin = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // password visibility
  bool passwordVisibility = true;

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RGB.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.lgSize * 2,
            horizontal: Dimensions.defaultSize,
          ),
          child: ListView(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(
                  bottom: Dimensions.lgSize,
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 90,
                ),
              ),
              const Text(
                'Welcome back',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: Dimensions.defaultSize * 1.5,
                  fontWeight: FontWeight.w700,
                  color: RGB.dark,
                ),
              ),
              const SizedBox(
                height: Dimensions.lgSize,
              ),
              Form(
                key: _formKeyLogin,
                child: Column(
                  children: [
                    TextFormField(
                      controller: userNameController,
                      keyboardType: TextInputType.text,
                      validator:
                          RequiredValidator(errorText: 'Username is required!'),
                      decoration: FormsUtils.inputStyle(
                        hintText: 'Username',
                      ),
                      cursorColor: RGB.dark,
                    ),
                    const SizedBox(height: Dimensions.lgSize),
                    TextFormField(
                      controller: passwordController,
                      obscureText: passwordVisibility,
                      keyboardType: TextInputType.text,
                      validator:
                          RequiredValidator(errorText: 'Password is required!'),
                      decoration: FormsUtils.inputStyle(
                        hintText: 'Password',
                        suffixIcon: UniconsLine.eye,
                        passwordVisibility: passwordVisibility,
                        suffixOnPressed: () {
                          setState(() {
                            passwordVisibility = !passwordVisibility;
                          });
                        },
                      ),
                      cursorColor: RGB.dark,
                    ),
                    const SizedBox(height: Dimensions.lgSize),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final form = _formKeyLogin.currentState;
                        if (form!.validate()) {
                          EasyLoading.show(status: 'loading...');
                          form.save();
                          // call api part
                          FormData formData = FormData.fromMap({
                            'username': userNameController.text,
                            'password': passwordController.text,
                          });
                          try {
                            Response response = await Dio().post(
                              URL.loginURL,
                              data: formData,
                            );
                            Map userData = jsonDecode(response.data);
                            if (userData['error']) {
                              SnackBarUtils.show(
                                  title: userData['message'], isError: true);
                            } else {
                              await Session().userSave(userData['user']);
                              SnackBarUtils.show(
                                  title: 'Login success', isError: false);
                              Get.offAllNamed('/home');
                            }
                          } catch (e) {
                            SnackBarUtils.show(
                                title: e.toString(), isError: true);
                          }
                          EasyLoading.dismiss();
                        }
                        return;
                      },
                      child: SizedBox(
                        width: Get.width,
                        child: const Text(
                          'Continue',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: Dimensions.smSize,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed('signup');
                },
                child: const Text(
                  'Sign up now',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: RGB.blue,
                  ),
                ),
              ),
              const SizedBox(
                height: Dimensions.smSize / 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  PhoneNumberFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!oldValue.text.contains("(") &&
        oldValue.text.length >= 10 &&
        newValue.text.length != oldValue.text.length) {
      return const TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (oldValue.text.length > newValue.text.length) {
      return TextEditingValue(
        text: newValue.text.toString(),
        selection: TextSelection.collapsed(offset: newValue.text.length),
      );
    }

    var newText = newValue.text;
    if (newText.length == 1) newText = "($newText";
    if (newText.length == 4) newText = "$newText) ";
    if (newText.length == 9) newText = "$newText ";

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
