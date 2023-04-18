import 'package:get/get.dart';

import '../modules/addEvent/bindings/add_event_binding.dart';
import '../modules/addEvent/views/add_event_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/delete/bindings/delete_binding.dart';
import '../modules/delete/views/delete_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const INITIAL = Routes.dashboard;
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.DELETE,
      page: () => const DeleteView(),
      binding: DeleteBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EVENT,
      page: () => const AddEventView(),
      binding: AddEventBinding(),
    ),
  ];
}
