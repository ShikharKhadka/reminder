import 'package:get/get.dart';

import '../controllers/delete_controller.dart';

class DeleteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeleteController>(
      () => DeleteController(),
    );
  }
}
