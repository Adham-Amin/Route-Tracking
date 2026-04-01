part of 'google_map_cubit.dart';

abstract class GoogleMapState {}

class GoogleMapInitial extends GoogleMapState {}

class GoogleMapLoading extends GoogleMapState {}

class GoogleMapLoaded extends GoogleMapState {}

class GoogleMapError extends GoogleMapState {
  final String failure;
  GoogleMapError({required this.failure});
}
