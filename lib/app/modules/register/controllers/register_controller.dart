import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController extends GetxController {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController confirmPasswordEditingController =
      TextEditingController();
  late String? emailErrorText;
  late String? passwordErrorText;
  late String? confirmPasswordErrorText;
  bool validate = false;
  @override
  void onInit() {
    print(validate);
    // registerUser();
    super.onInit();
  }
  Future<void> registerUser() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailEditingController.text,
        password: passwordEditingController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
  String onChanged(String value) {
    // if (value.isEmpty) {
    //   value = "Enter e-mail";
    //   return value;
    // }
    return value;
  }
  emailValidation() {
    if (emailEditingController.text.isEmpty) {
      emailErrorText = 'Empty Email address';
      validate = true;

      update();
    } else if (!emailEditingController.text.isEmail) {
      emailErrorText = 'Invalid email address';
      validate = true;
      update();
    } else {
      validate = false;
      emailErrorText = null;
      update();
    }
  }
  passwordValidation() {
    if (passwordEditingController.text.isEmpty) {
      passwordErrorText = 'Empty Password';
      validate = true;

      update();
    } else if (passwordEditingController.text.length < 6) {
      passwordErrorText = 'Password is short';
      validate = true;
      update();
    } else if (confirmPasswordEditingController.text !=
        passwordEditingController.text) {
      passwordErrorText = 'Password do not match';
      validate = true;
      update();
    } else {
      validate = false;
      passwordErrorText = null;
      update();
    }
  }

  confirmPasswordValidation() {
    if (confirmPasswordEditingController.text.isEmpty) {
      confirmPasswordErrorText = 'Empty Password';
      validate = true;

      update();
    } else if (confirmPasswordEditingController.text.length < 6) {
      confirmPasswordErrorText = 'Password is short';
      validate = true;
      update();
    } else if (confirmPasswordEditingController.text !=
        passwordEditingController.text) {
      confirmPasswordErrorText = 'Password do not match';
      validate = true;
      update();
    } else {
      validate = false;
      confirmPasswordErrorText = null;
      update();
    }
  }
  registerOnTap() {
    emailValidation();
    passwordValidation();
    confirmPasswordValidation();
  }
}
