import 'package:car_route/app/modules/map/map_controller.dart';
import 'package:car_route/app/ui/layouts/view_state_layout.dart';
import 'package:car_route/app/ui/widgets/loading_widgets/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends GetView<MapController> {
  const GoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ViewStateLayout(
          dataState: controller.mapDataState.value,
          loadingWidget: _buildLoadingWidget(),
          successWidget: _buildSuccessWidget(),
        );
      },
    );
  }

  _buildSuccessWidget() {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(23.8103, 90.4125),
        zoom: 14,
      ),
      onMapCreated: (c) {
        controller.mapController = c;
        controller.moveToCurrentLocation();
      },
      onCameraMove: controller.onCameraMove,
      onTap: controller.moveCenterTo,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: Set.of(controller.markers.values),
      polylines: Set.of(controller.polylines.values),
      trafficEnabled: controller.trafficEnabled.value,
      compassEnabled: true,
      zoomControlsEnabled: false,
    );
  }

  _buildLoadingWidget() {
    return ShimmerBox(
      width: double.infinity,
      height: double.infinity,
    );
  }
}
