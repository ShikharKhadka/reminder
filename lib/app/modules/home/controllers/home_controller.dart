import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';

import 'package:reminder/app/modules/database/notification_db.dart';
import 'package:reminder/app/modules/model/notification_db_model.dart';
import 'package:reminder/app/utils/date_time_component_enum.dart';
import 'package:reminder/notification/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:reminder/app/modules/home/views/home_view.dart';

class HomeController extends GetxController {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descEditingController = TextEditingController();
  late List<DateTimeComponentEnum> dateTimeComponentList;
  DateTimeComponents dateTimeComponents = DateTimeComponents.dayOfWeekAndTime;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<DateTime> dateTimeList = [];
  bool validate = false;
  late DateTimeComponents getDateTimeComponents;
  late List<Repeat> repeat;
  List<NotificationDdModel> notificationDbList = [];
  TimePeriod timePeriod = TimePeriod.week;
  Repeat repeatValue = Repeat.one;
  late ScrollController scrollController;
  final FocusNode textFocus = FocusNode();
  late String? titleErrorText;
  late String? descriptionErrorText;

  @override
  void onInit() async {
    scrollController = ScrollController()..addListener(scrollListener);

    tz.initializeTimeZones();
    dateTimeComponentList = DateTimeComponentEnum.values;
    repeat = Repeat.values;

    super.onInit();
  }

  // Future<void> registerUser() async {
  //   try {
  //     final credential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: 'shikhar12763@gmail.com',
  //       password: 'password123@',
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('The account already exists for that email.');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> loginUser() async {
  //   try {
  //     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: 'shikhar12763@gmail.com',
  //       password: 'password123@',
  //     );
  //     final idToken = await credential.user!.getIdTokenResult();
  //     final id = idToken.token;
  //     print(id);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     }
  //   }
  // }

  void scrollListener() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  getTime(String val) async {
    DateFormat format = DateFormat("yyyy-MM-dd hh:mm");
    var formatedDateTime = (format.parse(val));
    dateTimeList.add(formatedDateTime);

    update();
  }

  radioButtonValue(TimePeriod? value) {
    timePeriod = value!;
    if (timePeriod == TimePeriod.day) {
      dateTimeComponents = DateTimeComponents.time;
      update();
    }
    if (timePeriod == TimePeriod.month) {
      dateTimeComponents = DateTimeComponents.dayOfMonthAndTime;
      update();
    }
    if (timePeriod == TimePeriod.week) {
      dateTimeComponents = DateTimeComponents.dayOfWeekAndTime;

      update();
    }
    if (timePeriod == TimePeriod.year) {
      dateTimeComponents = DateTimeComponents.dateAndTime;

      update();
    }
  }

  repeatRadioButtonValue(value) {
    repeatValue = value!;
    update();
  }

  titleValidation() {
    if (titleEditingController.text.isEmpty) {
      validate = true;
      titleErrorText = ' Enter Title';
      update();
    } else {
      validate = false;
      titleErrorText = null;
      update();
    }
  }

  descriptionValidation() {
    if (descEditingController.text.isEmpty) {
      validate = true;
      descriptionErrorText = ' Enter Description';
    } else {
      validate = false;
      descriptionErrorText = null;
      update();
    }
  }

  dateValidation() {
    if (dateTimeList.isEmpty) {
      Get.snackbar('DateTime', 'Enter date time');
    } else {
      return null;
    }
  }

  onFieldTitleSubmitted(String value) {
    titleEditingController.text = value;
    update();
  }

  onFieldDescriptionSubmitted(String value) {
    descEditingController.text = value;
    update();
  }

  sendNotification() async {
    if (titleEditingController.text.isEmpty ||
        descEditingController.text.isEmpty ||
        dateTimeList.isEmpty) {
      titleValidation();
      descriptionValidation();
      dateValidation();
    } else {
      // Get.back(result: {"notificationDbList": notificationDbList});
      Get.defaultDialog(
          title: "Are you sure you want to send notification?",
          content: Column(
            children: [
              Text(titleEditingController.text),
              Text(descEditingController.text),
              for (var i in dateTimeList)
                Text(DateFormat('EEEE, d MMM, yyyy hh:mm a ')
                    .format(DateTime.parse(i.toString())))
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Get.back();
              },
              child: const Text('Edit'),
            ),
            ElevatedButton(
              onPressed: () async {
                Random random = Random();
                for (int i = 0; i < dateTimeList.length; i++) {
                  int randomNumber = random.nextInt(10000);
                  await NotificationService().showNotification(
                      randomNumber,
                      titleEditingController.text,
                      descEditingController.text,
                      dateTimeList[i],
                      dateTimeComponents);
                  await NotificationDatabase.notificationDatabase
                      .insertNotification({
                    'notificationId': randomNumber,
                    'dateTimeList': dateTimeList[i].toString(),
                    'title': titleEditingController.text,
                    'description': descEditingController.text
                  });
                }
                await getNotificationDb();
                dateTimeList.clear();
                update();
                Get.back(
                    result: {"notificationDbList": notificationDbList},
                    closeOverlays: true);
              },
              child: const Text('Ok'),
            ),
          ],
          radius: 30);
    }
  }

  getNotificationDb() async {
    List<NotificationDdModel> notificationDd =
        await NotificationDatabase.notificationDatabase.queryNotification();
    if (notificationDd.isNotEmpty) {
      notificationDbList.addAll(notificationDd);
      update();
      return notificationDbList;
    }
  }

  clearSelectedDateList() {
    dateTimeList.clear();
    update();
  }

  void dismissKeyboard() {
    if (textFocus.hasFocus) {
      textFocus.unfocus();
    }
  }
}
