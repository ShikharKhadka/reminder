import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reminder/app/modules/database/deleted_notification_db.dart';
import 'package:reminder/app/utils/app_textfield.dart';
import 'package:reminder/app/utils/app_theme.dart';

import '../controllers/delete_controller.dart';

class DeleteView extends GetView<DeleteController> {
  const DeleteView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeleteController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            title: const Text('DeleteView'),
            centerTitle: true,
          ),
          body: controller.deletedNotificatioNList.isEmpty
              ? const Center(
                  child: Text('No notification deleted'),
                )
              : ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppTextField(
                        controller: controller.searchEditingController,
                        hintText: 'Search here',
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: controller.searchTap,
                            icon: const Icon(
                              Icons.search,
                              size: 20,
                            ),
                          ),
                        ),
                        onField: (value) {
                          controller.searchEditingController.text = value;
                          controller.update();
                        },
                        onChanged: controller.onChanged,
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.searchFilter.length,
                        itemBuilder: (context, index) {
                          final deletedNotification =
                              controller.searchFilter[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      DateFormat('d ').format(
                                        DateTime.parse(
                                            deletedNotification.dateTimeList!),
                                      ),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('EEEE ').format(
                                            DateTime.parse(deletedNotification
                                                .dateTimeList!),
                                          ),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          DateFormat(' MMM, yyyy ').format(
                                            DateTime.parse(deletedNotification
                                                .dateTimeList!),
                                          ),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        DeletedNotificationDatabase
                                            .deletednotificationDatabase
                                            .deleteNotification(
                                                deletedNotification
                                                    .notificationId);
                                        controller.refreshDatabase();
                                        controller.update();
                                      },
                                      icon: const Icon(Icons.delete),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(deletedNotification.title!),
                                              Text(deletedNotification
                                                  .description!),
                                            ],
                                          ),
                                          Text(
                                            DateFormat('hh:mm a ').format(
                                              DateTime.parse(deletedNotification
                                                  .dateTimeList!),
                                            ),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ],
                ),
        );
      },
    );
  }
}
