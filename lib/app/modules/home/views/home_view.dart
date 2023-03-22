import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:reminder/app/utils/app_theme.dart';
import 'package:reminder/app/utils/date_time_component_enum.dart';

import '../controllers/home_controller.dart';

enum TimePeriod { day, month, week, year }

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          centerTitle: true,
          title: const Text(' Add Reminder'),
        ),
        body: SingleChildScrollView(
          controller: controller.scrollController,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: controller.titleEditingController,
                  onFieldSubmitted: controller.onFieldTitleSubmitted,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorText:
                        controller.validate ? controller.titleErrorText : null,
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    hintText: 'Title',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: controller.descEditingController,
                  onFieldSubmitted: controller.onFieldDescriptionSubmitted,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorText: controller.validate
                        ? controller.descriptionErrorText
                        : null,
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    hintText: 'Descprition',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Repeat ',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: List.generate(
                    controller.dateTimeComponentList.length,
                    (index) => Card(
                      child: ListTile(
                        title: Text(controller
                            .dateTimeComponentList[index].displayName),
                        leading: Radio<TimePeriod>(
                          activeColor: AppTheme.primaryColor,
                          value: TimePeriod.values[index],
                          groupValue: controller.timePeriod,
                          onChanged: controller.radioButtonValue,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Chose Date and Time',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 20),
                        child: DateTimePicker(
                          type: DateTimePickerType.dateTime,
                          dateMask: 'yMMMMd     hh:mm',
                          initialValue: DateTime.now().toString(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: const Icon(Icons.event),
                          dateLabelText: 'Date',
                          timeLabelText: "Hour",
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          selectableDayPredicate: (date) {
                            // Disable weekend days to select from the calendar

                            return true;
                          },
                          onChanged: controller.getTime,
                          validator: (val) {
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                controller.dateTimeList.isNotEmpty
                    ? const Center(
                        child: Text(
                          'Selected Date',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      )
                    : const SizedBox(),
                controller.dateTimeList.isNotEmpty
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: 10,
                            spacing: 10,
                            children: List.generate(
                              controller.dateTimeList.length,
                              (index) => Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black)),
                                child: Center(
                                  child: Text(
                                    controller.dateTimeList[index]
                                        .toString()
                                        .substring(0, 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        onPressed: controller.clearSelectedDateList,
                        child: const Text(
                          'Clear Selected Date',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        onPressed: controller.sendNotification,
                        child: const Text(
                          'Send Reminder',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
