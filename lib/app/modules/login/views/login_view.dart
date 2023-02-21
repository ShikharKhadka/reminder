import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reminder/app/utils/app_textfield.dart';
import 'package:reminder/app/utils/app_theme.dart';
import 'package:reminder/app/routes/app_pages.dart';
import 'package:reminder/app/utils/form_inputs.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              color: AppTheme.primaryColor,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Center(
                      child: Text(
                        'Login',
                        style: AppTheme.registerTitleStyle,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Welcome back!',
                              style: TextStyle(
                                  color: AppTheme.textColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                      color: AppTheme.textfieldNameColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.REGISTER);
                                  },
                                  child: const Text(
                                    '  Register',
                                    style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Your e-mail',
                          style: TextStyle(
                              color: AppTheme.textColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GetBuilder<LoginController>(
                          builder: (controller) {
                            return AppTextField(
                              hintText: 'Enter your email',
                              currentValue: controller.form.email.value,
                              validationError: controller.form.email.error,
                              onChanged: (value) {
                                controller.form.email =
                                    EmailInput.dirty(value: value);
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Password',
                          style: TextStyle(
                              color: AppTheme.textColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GetBuilder<LoginController>(
                          builder: (controller) {
                            return AppTextField(
                              hintText: 'Enter your passwprd',
                              currentValue: controller.form.password.value,
                              validationError: controller.form.password.error,
                              onChanged: (value) {
                                controller.form.password =
                                    PasswordInput.dirty(value: value);
                                controller.update();
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: AppTheme.primaryColor),
                              onPressed: controller.onLogin,
                              child: const Text('Login '),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
