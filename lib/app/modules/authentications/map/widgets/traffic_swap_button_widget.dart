import 'package:car_route/app/modules/authentications/map/map_controller.dart';
import 'package:car_route/app/ui/theme/colors.dart';
import 'package:car_route/app/utils/ui_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrafficSwapButtonWidget extends GetView<MapController> {
  const TrafficSwapButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: UISpacing.small,
      left: UISpacing.small,
      child: Obx(
        () => FloatingActionButton(
          backgroundColor: controller.trafficEnabled.value ? primaryColor : secondaryColor,
          onPressed: controller.toggleTraffic,
          child: Icon(
            Icons.traffic,
            color: controller.trafficEnabled.value ? secondaryColor : primaryColor,
          ),
        ),
      ),
    );
  }
}
