import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routing_tracker/core/services/location_service.dart';
import 'package:routing_tracker/features/google_map/presentation/widgets/search_section.dart';

class CustomGoogleMapsViewBody extends StatefulWidget {
  const CustomGoogleMapsViewBody({super.key});

  @override
  State<CustomGoogleMapsViewBody> createState() =>
      _CustomGoogleMapsViewBodyState();
}

class _CustomGoogleMapsViewBodyState extends State<CustomGoogleMapsViewBody> {
  late GoogleMapController googleMapController;
  late CameraPosition initialCameraPosition;
  late LocationServices locationService;
  Set<Marker> markers = {};

  @override
  void initState() {
    locationService = LocationServices();
    initialCameraPosition = const CameraPosition(
      target: LatLng(28.6483557, 30.8303655),
      zoom: 6,
    );
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            googleMapController = controller;
            getCurrentLocation();
          },
          initialCameraPosition: initialCameraPosition,
          markers: markers,
        ),
        Positioned(top: 60, left: 20, right: 20, child: SearchSection()),
      ],
    );
  }

  void getLocationStream() {
    locationService.getLocationStream().listen((location) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.latitude!, location.longitude!),
            zoom: 18,
          ),
        ),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('myLocation'),
          position: LatLng(location.latitude!, location.longitude!),
        ),
      );
      setState(() {});
    });
  }

  void getCurrentLocation() {
    locationService.getCurrentLocation().then((location) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.latitude!, location.longitude!),
            zoom: 18,
          ),
        ),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('myLocation'),
          position: LatLng(location.latitude!, location.longitude!),
        ),
      );
      setState(() {});
    });
  }
}
