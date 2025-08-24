import 'package:car_route/app/modules/authentications/map/map_controller.dart';
import 'package:car_route/app/utils/ui_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DestinationSwapButtonWidget extends GetView<MapController> {
  const DestinationSwapButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: UISpacing.small,
      right: UISpacing.small,
      child: Obx(() {
        final bothSelected = controller.origin.value != null && controller.destination.value != null;
        return bothSelected
            ? FloatingActionButton(
                onPressed: controller.swapLocations,
                child: const Icon(Icons.swap_vert),
              )
            : SizedBox();
      }),
    );
  }
}
