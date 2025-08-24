import 'dart:developer';

import 'package:car_route/app/core/apis/api_client.dart';
import 'package:car_route/app/core/apis/api_endpoints.dart';

class AuthServices {
  final apiClient = ApiClient();

  Future<dynamic> signIn(String mobileNumber, String password) async {
    try {
      final response = await apiClient.dio.post(
        ApiEndpoints.signIn,
        data: {'mobile_number': mobileNumber, 'password': password},
      );

      log('-------------------------------');
      log(response.toString());
      log('-------------------------------');
      log(response.statusCode.toString());
      log('-------------------------------');
      log(response.data.toString());
      log('-------------------------------');
      log(response.statusMessage.toString());
      log('-------------------------------');

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
