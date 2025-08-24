import 'package:car_route/app/modules/map/map_controller.dart';
import 'package:car_route/app/ui/widgets/buttons/main_button_widget.dart';
import 'package:car_route/app/utils/ui_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapActionButtonWidget extends GetView<MapController> {
  const MapActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: UISpacing.small,
      left: UISpacing.small,
      child: Obx(() {
        final bothSelected = controller.origin.value != null && controller.destination.value != null;

        // Decide label based on selection state
        String label;
        if (bothSelected) {
          label = 'startOver'.tr;
        } else if (controller.origin.value == null) {
          label = 'confirmOrigin'.tr;
        } else {
          label = 'confirmDestination'.tr;
        }

        return MainButtonWidget(
          fullWidth: true,
          loading: controller.isOriginLoading.value || controller.isDestinationLoading.value,
          label: label,
          onPressed: () async {
            if (bothSelected) {
              controller.reset();
            } else {
              // Confirm the current center as origin or destination
              if (controller.origin.value == null) {
                await controller.setOrigin(controller.currentCenter.value);
              } else {
                await controller.setDestination(controller.currentCenter.value);
                await controller.buildRoute();
              }
            }
          },
        );
      }),
    );
  }
}
