import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  // password visibility
  bool passwordVisibility = true;
  // gender
  String selectedGender = 'male';
  // date of birth
  bool isDatePicked = false;
  DateTime dateOfBirth = DateTime.now();
  // country code picked
  bool countryCodePicked = false;
  String dialCode = '';

  @override
  void dispose() {
    nameController.dispose();
    surNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RGB.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(
            Dimensions.defaultSize,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  validator:
                      RequiredValidator(errorText: 'This field is required!'),
                  decoration: FormsUtils.inputStyle(
                    hintText: 'Username',
                  ),
                  cursorColor: RGB.dark,
                ),
                const SizedBox(height: Dimensions.lgSize),
                TextFormField(
                  obscureText: passwordVisibility,
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  validator:
                      RequiredValidator(errorText: 'This field is required!'),
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
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: mobileController,
                  validator:
                      RequiredValidator(errorText: 'This field is required!'),
                  decoration: FormsUtils.inputStyle(
                    hintText: 'Mobile number',
                  ),
                  cursorColor: RGB.dark,
                ),
                const SizedBox(height: Dimensions.lgSize),
                const SizedBox(height: Dimensions.lgSize),
                ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      EasyLoading.show(status: 'loading...');
                      form.save();
                      // call api part
                      FormData formData = FormData.fromMap({
                        'name': nameController.text,
                        'username': nameController.text.trim(),
                        'phone': mobileController.text,
                        'password': passwordController.text,
                      });
                      try {
                        Response response = await Dio().post(
                          URL.signUpURL,
                          data: formData,
                        );
                        Map userData = jsonDecode(response.data);
                        if (userData['error']) {
                          SnackBarUtils.show(
                              title: 'Error Occurs', isError: true);
                        } else {
                          await Session().userSave(userData['user']);
                          SnackBarUtils.show(
                              title: 'Registration success', isError: false);
                          Get.offAllNamed('/home');
                        }
                      } catch (e) {
                        SnackBarUtils.show(title: e.toString(), isError: true);
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
        ),
      ),
    );
  }

  Future dateOfBirthPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateOfBirth,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1950),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        dateOfBirth = picked;
        isDatePicked = true;
      });
    }
  }
}
