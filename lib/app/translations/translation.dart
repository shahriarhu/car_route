import 'package:car_route/app/translations/bd_bn.dart';
import 'package:car_route/app/translations/en_us.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_us': enUs, 'bd_bn': bdBn};
}
