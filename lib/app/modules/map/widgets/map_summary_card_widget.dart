import 'package:car_route/app/modules/map/map_controller.dart';
import 'package:car_route/app/ui/widgets/texts/titles.dart';
import 'package:car_route/app/utils/ui_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapSummaryCardWidget extends GetView<MapController> {
  const MapSummaryCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: UISpacing.small,
      right: UISpacing.small,
      bottom: 80,
      child: Obx(() {
        final bothSelected = controller.origin.value != null && controller.destination.value != null;
        return (bothSelected && controller.distance.isNotEmpty)
            ? Card(
                elevation: 4,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleMedium(
                        text: 'distanceWithValue'.trParams({'value': controller.distance.value}),
                      ),
                      TitleMedium(
                        text: 'etaWithValue'.trParams({'value': controller.duration.value}),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox();
      }),
    );
  }
}
