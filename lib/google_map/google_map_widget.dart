import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'place.dart';

class GoogleMapWidget extends StatelessWidget {
  final Place? selectedPlace;
  const GoogleMapWidget({super.key, this.selectedPlace});

  @override
  Widget build(BuildContext context) {
    if (selectedPlace == null) {
      return const Center(child: Text('장소를 선택해 주세요.'));
    }
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(selectedPlace!.lat, selectedPlace!.lng),
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: MarkerId(selectedPlace!.name),
          position: LatLng(selectedPlace!.lat, selectedPlace!.lng),
          infoWindow: InfoWindow(
            title: selectedPlace!.name,
            snippet: selectedPlace!.address,
          ),
        ),
      },
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
    );
  }
}
