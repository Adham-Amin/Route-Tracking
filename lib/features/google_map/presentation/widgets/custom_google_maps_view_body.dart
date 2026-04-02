import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routing_tracker/core/services/location_service.dart';
import 'package:routing_tracker/features/google_map/presentation/cubit/google_map_cubit.dart';
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
  late LatLng currentLocation;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

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
          onMapCreated: (controller) {
            googleMapController = controller;
            getLocationStream();
          },
          initialCameraPosition: initialCameraPosition,
          markers: markers,
          polylines: polylines,
        ),
        Positioned(
          top: 60,
          left: 20,
          right: 20,
          child: SearchSection(
            onTap: (destination) async {
              var destinationMarker = Marker(
                markerId: const MarkerId('destination'),
                position: LatLng(
                  destination.lat.toDouble(),
                  destination.lon.toDouble(),
                ),
              );
              markers.add(destinationMarker);
              setState(() {});
              await context.read<GoogleMapCubit>().getPolylinePoints(
                origin: currentLocation,
                destination: LatLng(
                  destination.lat.toDouble(),
                  destination.lon.toDouble(),
                ),
              );
              drawPolyline(context.read<GoogleMapCubit>().polylinePoints);
            },
          ),
        ),
      ],
    );
  }

  void drawPolyline(List<LatLng> points) {
    polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: points,
      ),
    };
    setState(() {});
  }

  void getLocationStream() {
    locationService.getLocationStream().listen((location) {
      currentLocation = LatLng(location.latitude!, location.longitude!);
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.latitude!, location.longitude!),
            zoom: 18,
          ),
        ),
      );
      var currentMarker = Marker(
        markerId: const MarkerId('myLocation'),
        position: LatLng(location.latitude!, location.longitude!),
      );
      markers.add(currentMarker);
      setState(() {});
    });
  }

  void getCurrentLocation() {
    locationService.getCurrentLocation().then((location) {
      currentLocation = LatLng(location.latitude!, location.longitude!);
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.latitude!, location.longitude!),
            zoom: 18,
          ),
        ),
      );
      var currentMarker = Marker(
        markerId: const MarkerId('myLocation'),
        position: LatLng(location.latitude!, location.longitude!),
      );
      markers.add(currentMarker);
      setState(() {});
    });
  }
}
