import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routing_tracker/core/services/custom_observer_bloc.dart';
import 'package:routing_tracker/features/google_map/presentation/pages/custom_google_maps_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = CustomObserverBloc();
  runApp(const RouteTracking());
}

class RouteTracking extends StatelessWidget {
  const RouteTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomGoogleMapsView(),
    );
  }
}
