import 'package:car_route/app/modules/authentications/map/map_controller.dart';
import 'package:car_route/app/modules/authentications/map/map_repository.dart';
import 'package:car_route/app/modules/authentications/map/map_services.dart';
import 'package:get/get.dart';

class MapBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapServices>(() => MapServices());
    Get.lazyPut<MapRepository>(() => MapRepository(Get.find()));
    Get.lazyPut<MapController>(() => MapController(Get.find()));
  }
}
