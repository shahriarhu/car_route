import 'package:car_route/app/modules/_export.dart';
import 'package:car_route/app/routes/app_routes.dart';
import 'package:car_route/app/utils/user_provider.dart';
import 'package:get/get.dart';

abstract class AppPages {
  AppPages._();

  static String getInitialPage() {
    bool isSignedIn = UserProvider.userCred.token?.isNotEmpty ?? false;

    if (isSignedIn) {
      return AppRoutes.map;
    } else {
      return AppRoutes.map;
    }
  }

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.map,
      page: () => const MapView(),
      binding: MapBindings(),
    ),
  ];
}
