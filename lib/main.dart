import 'package:car_route/app/core/apis/environment.dart';
import 'package:car_route/app/routes/app_pages.dart';
import 'package:car_route/app/translations/language_controller.dart';
import 'package:car_route/app/translations/translation.dart';
import 'package:car_route/app/ui/theme/theme.dart';
import 'package:car_route/app/ui/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RootBinding().dependencies();

  await GetStorage.init();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Route App',
      initialRoute: AppPages.getInitialPage(),
      getPages: AppPages.routes,
      // initialBinding: InitialBinding(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeController.getThemeMode,
      translations: AppTranslations(),
      locale: langController.selectedLocale,
      fallbackLocale: langController.localeEn.locale,
    ),
  );
}

class RootBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    EnvironmentConfig.init(Environment.development);

    await GetStorage.init();

    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    Get.lazyPut<LanguageController>(() => LanguageController(), fenix: true);
  }
}
