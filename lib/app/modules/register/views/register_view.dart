import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reminder/app/utils/app_textfield.dart';
import 'package:reminder/app/utils/app_theme.dart';
import 'package:reminder/app/routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      builder: (controller) {
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
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Center(
                          child: Text(
                            'Register',
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
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'Create an account',
                                    style: TextStyle(
                                        color: AppTheme.textColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
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
                              AppTextField(
                                hintText: 'Enter your email',
                                errorText: controller.validate
                                    ? controller.emailErrorText
                                    : null,
                                controller: controller.emailEditingController,
                                onField: ((value) {
                                  controller.emailEditingController.text =
                                      value;
                                  controller.update();
                                }),
                                onChanged: controller.onChanged,
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
                              AppTextField(
                                hintText: 'Enter your password',
                                controller:
                                    controller.passwordEditingController,
                                errorText: controller.validate
                                    ? controller.passwordErrorText
                                    : null,
                                onField: (value) {
                                  controller.passwordEditingController.text =
                                      value;

                                  controller.update();
                                },
                                // onChanged: (p0) {
                                //   print(p0);
                                //   if (!GetUtils.isEmail(p0)) {
                                //     controller.errorText = 'Invalid email';
                                //     controller.update();
                                //   } else {
                                //     controller.errorText = 'Empty Email';
                                //     controller.update();
                                //   }
                                // },
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
                              AppTextField(
                                controller:
                                    controller.confirmPasswordEditingController,
                                errorText: controller.validate
                                    ? controller.confirmPasswordErrorText
                                    : null,
                                hintText: 'Repeat your password',
                                onChanged: (value) {
                                  controller.confirmPasswordEditingController
                                      .text = value;

                                  controller.update();
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          backgroundColor:
                                              AppTheme.primaryColor),
                                      onPressed: controller.registerOnTap,
                                      child: const Text('Sign Up')),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          backgroundColor:
                                              AppTheme.primaryColor),
                                      onPressed: () {
                                        Get.toNamed(Routes.LOGIN);
                                      },
                                      child: const Text('Login ')),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
