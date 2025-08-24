import 'package:car_route/app/core/commons/models/auth_user_model.dart';
import 'package:get_storage/get_storage.dart';

class UserProvider {
  UserProvider._();

  static final GetStorage _getStorage = GetStorage();

  static dynamic get _user => _getStorage.read('authUser');

  ///Get
  static AuthUserModel get userCred => _user != null ? authUserModelFromJson(_user) : AuthUserModel();

  ///Set
  static void setUser(String jsonString) async {
    await _getStorage.write('authUser', jsonString);
  }

  ///Remove
  static void removeUser() async {
    await _getStorage.remove('authUser');
  }
}
