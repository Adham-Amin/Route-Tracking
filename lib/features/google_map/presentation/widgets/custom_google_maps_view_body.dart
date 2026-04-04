import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:routing_tracker/core/services/location_service.dart';
import 'package:routing_tracker/features/google_map/domain/entities/place_entity.dart';
import 'package:routing_tracker/features/google_map/presentation/cubit/google_map_cubit.dart';
import 'package:routing_tracker/features/google_map/presentation/widgets/search_section.dart';

class CustomGoogleMapsViewBody extends StatefulWidget {
  const CustomGoogleMapsViewBody({super.key});

  @override
  State<CustomGoogleMapsViewBody> createState() =>
      _CustomGoogleMapsViewBodyState();
}

class _CustomGoogleMapsViewBodyState extends State<CustomGoogleMapsViewBody> {
  late GoogleMapController _mapController;
  late LocationServices _locationService;
  late StreamSubscription _locationSubscription;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  LatLng? _currentLocation;

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(28.6483557, 30.8303655),
    zoom: 6,
  );

  @override
  void initState() {
    super.initState();
    _locationService = LocationServices();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildGoogleMap(),
        _buildSearchSection(),
        _buildStreamLocationButton(),
      ],
    );
  }

  // ================= UI =================

  Widget _buildGoogleMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: _initialCameraPosition,
      markers: _markers,
      polylines: _polylines,
    );
  }

  Widget _buildSearchSection() {
    return Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: SearchSection(onTap: _onDestinationSelected),
    );
  }

  // ================= Map Logic =================

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    getCurrentLocation();
  }

  Future<void> _onDestinationSelected(PlaceEntity destination) async {
    if (_currentLocation == null) return;

    final LatLng destinationLatLng = LatLng(
      destination.lat.toDouble(),
      destination.lon.toDouble(),
    );

    _addDestinationMarker(destinationLatLng);

    await context.read<GoogleMapCubit>().getPolylinePoints(
      origin: _currentLocation!,
      destination: destinationLatLng,
    );

    _drawPolyline();

    _moveCameraToBounds();
  }

  void _addDestinationMarker(LatLng destination) {
    final marker = Marker(
      markerId: const MarkerId('destination'),
      position: destination,
    );

    _markers.add(marker);
    setState(() {});
  }

  void _drawPolyline() {
    _polylines.clear();

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: context.read<GoogleMapCubit>().polylinePoints,
      ),
    );

    setState(() {});
  }

  void _moveCameraToBounds() {
    final points = context.read<GoogleMapCubit>().polylinePoints;
    var northeast = LatLng(points[0].latitude, points[0].longitude);
    var southwest = LatLng(points[0].latitude, points[0].longitude);

    for (var point in points) {
      northeast = LatLng(
        max(northeast.latitude, point.latitude),
        max(northeast.longitude, point.longitude),
      );
      southwest = LatLng(
        min(southwest.latitude, point.latitude),
        min(southwest.longitude, point.longitude),
      );
    }
    var bounds = LatLngBounds(northeast: northeast, southwest: southwest);
    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 64));
  }

  void _updateCurrentLocation(LocationData location) {
    final LatLng newLocation = LatLng(location.latitude!, location.longitude!);

    _currentLocation = newLocation;

    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: newLocation, zoom: 18),
      ),
    );

    _updateMyLocationMarker(newLocation);
  }

  void _updateMyLocationMarker(LatLng location) {
    _markers.removeWhere((m) => m.markerId.value == 'myLocation');

    _markers.add(
      Marker(markerId: const MarkerId('myLocation'), position: location),
    );

    setState(() {});
  }

  void getLocationStream() {
    _locationSubscription = _locationService.getLocationStream().listen((
      location,
    ) {
      _updateCurrentLocation(location);
    });
  }

  void getCurrentLocation() {
    _locationService.getCurrentLocation().then((location) {
      _updateCurrentLocation(location);

      var marker = Marker(
        markerId: const MarkerId('CurrentLocation'),
        position: _currentLocation!,
      );

      _markers.add(marker);

      setState(() {});
    });
  }

  Widget _buildStreamLocationButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: () => getLocationStream(),
      ),
    );
  }
}
