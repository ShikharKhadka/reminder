import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:get/get.dart';
import 'package:reminder/app/utils/form_inputs.dart';

class LoginForm with FormzMixin {
  LoginForm({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
  });

  EmailInput email;
  PasswordInput password;

  @override
  List<FormzInput> get inputs => [email, password];
}

class LoginController extends GetxController {
  LoginForm form = LoginForm();

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onLogin() {
    print('object');
    if (form.email.pure) {
      form.email = const EmailInput.dirty();
    }
    if (form.password.pure) {
      form.password = const PasswordInput.dirty();
    }

    update();

    if (form.status == FormzStatus.valid) {
      print("${form.email.value}, ${form.password.value}");
    }
  }
}
