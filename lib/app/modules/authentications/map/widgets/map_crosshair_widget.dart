import 'package:car_route/app/modules/authentications/map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapCrosshairWidget extends GetView<MapController> {
  const MapCrosshairWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bothSelected = controller.origin.value != null && controller.destination.value != null;

      return bothSelected
          ? SizedBox()
          : IgnorePointer(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Icon(
                    Icons.location_pin,
                    size: 32,
                    color: Colors.red,
                  ),
                ),
              ),
            );
    });
  }
}
