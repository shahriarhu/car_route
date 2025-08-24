import 'package:car_route/app/routes/app_routes.dart';
import 'package:car_route/app/utils/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (UserProvider.userCred.token == null || UserProvider.userCred.token == '') {
      return const RouteSettings(name: AppRoutes.signIn);
    }
    return null;
  }
}
