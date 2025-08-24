import 'dart:convert';

import 'package:car_route/app/core/commons/models/response_model.dart';
import 'package:car_route/app/modules/authentications/auth_services.dart';
import 'package:car_route/app/utils/user_provider.dart';

class AuthRepository {
  final AuthServices _authService = AuthServices();

  Future<ResponseModel> signIn(String email, String password) async {
    final data = await _authService.signIn(email, password);

    UserProvider.setUser(jsonEncode(data));

    return ResponseModel();
  }
}
