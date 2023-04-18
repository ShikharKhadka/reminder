import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_event_controller.dart';

class AddEventView extends GetView<AddEventController> {
  const AddEventView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddEventController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AddEventView'),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: controller.checkOnTap,
                  icon: const Icon(Icons.check))
            ],
          ),
          body: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.text_format),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextFormField(
                            decoration: const InputDecoration(hintText: "Text"),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextFormField(
                            decoration:
                                const InputDecoration(hintText: "Location"),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: DateTimePicker(
                              type: DateTimePickerType.dateTime,

                              initialValue: DateTime.now().toString(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              // icon: const Icon(Icons.event),
                              // dateMask: 'd MMM, yyyy',
                              use24HourFormat: true,

                              timeLabelText: "Hour",
                              textAlign: TextAlign.start,
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
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
