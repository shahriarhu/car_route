import 'dart:ui';

import 'package:car_route/app/translations/language_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController implements GetxService {
  static LanguageController instance = Get.find();
  final _getStorage = GetStorage();
  static const lang = "lang";

  LanguageModel localeEn = LanguageModel(
    code: 'en',
    title: 'English',
    locale: const Locale('en', 'US'),
    // flag: LocalImages.ukFlag,
  );
  LanguageModel localeBn = LanguageModel(
    code: 'bn',
    title: 'Bangla',
    locale: const Locale('bn', 'BN'),
    // flag: LocalImages.bdFlag,
  );

  List<LanguageModel> get languages => [localeEn, localeBn];

  Locale get selectedLocale =>
      _getStorage.read(lang) == null || _getStorage.read(lang) == 'en' ? const Locale('en', 'US') : localeBn.locale;

  void setLocale(Locale locale) {
    _getStorage.write(lang, locale.languageCode);
    Get.updateLocale(locale);
    update();
  }
}

LanguageController langController = LanguageController.instance;
