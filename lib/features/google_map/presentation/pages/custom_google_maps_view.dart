import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routing_tracker/core/services/api_service.dart';
import 'package:routing_tracker/features/google_map/data/datasources/google_map_data_source.dart';
import 'package:routing_tracker/features/google_map/data/repositories/google_map_repo_impl.dart';
import 'package:routing_tracker/features/google_map/presentation/cubit/google_map_cubit.dart';
import 'package:routing_tracker/features/google_map/presentation/widgets/custom_google_maps_view_body.dart';

class CustomGoogleMapsView extends StatelessWidget {
  const CustomGoogleMapsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoogleMapCubit(
        googleMapRepo: GoogleMapRepoImpl(
          googleMapDataSource: GoogleMapDataSourceImpl(
            apiService: ApiService(Dio()),
          ),
        ),
      ),
      child: const Scaffold(body: CustomGoogleMapsViewBody()),
    );
  }
}
