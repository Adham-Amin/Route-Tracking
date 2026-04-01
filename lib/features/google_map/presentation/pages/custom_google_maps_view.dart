import 'package:flutter/material.dart';
import 'package:routing_tracker/features/google_map/presentation/widgets/custom_google_maps_view_body.dart';

class CustomGoogleMapsView extends StatelessWidget {
  const CustomGoogleMapsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CustomGoogleMapsViewBody());
  }
}
