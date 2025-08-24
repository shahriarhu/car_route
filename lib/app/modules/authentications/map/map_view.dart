import 'package:car_route/app/modules/authentications/map/widgets/destination_swap_button_widget.dart';
import 'package:car_route/app/modules/authentications/map/widgets/google_map_widget.dart';
import 'package:car_route/app/modules/authentications/map/widgets/map_action_button_widget.dart';
import 'package:car_route/app/modules/authentications/map/widgets/map_crosshair_widget.dart';
import 'package:car_route/app/modules/authentications/map/widgets/map_summary_card_widget.dart';
import 'package:car_route/app/modules/authentications/map/widgets/traffic_swap_button_widget.dart';
import 'package:car_route/app/ui/widgets/texts/titles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleLarge(text: 'carRoute'.tr),
      ),
      body: Stack(
        children: [
          const GoogleMapWidget(),
          const MapCrosshairWidget(),
          const MapSummaryCardWidget(),
          const MapActionButtonWidget(),
          const TrafficSwapButtonWidget(),
          const DestinationSwapButtonWidget(),
        ],
      ),
    );
  }
}
