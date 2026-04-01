import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routing_tracker/features/google_map/domain/entities/place_entity.dart';
import 'package:routing_tracker/features/google_map/presentation/cubit/google_map_cubit.dart';

class SearchList extends StatelessWidget {
  const SearchList({super.key, required this.onTap});

  final Function(PlaceEntity) onTap;

  @override
  Widget build(BuildContext context) {
    var placeList = context.watch<GoogleMapCubit>().places;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: BlocBuilder<GoogleMapCubit, GoogleMapState>(
        builder: (context, state) {
          if (state is GoogleMapLoaded) {
            return ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Colors.grey),
              itemCount: placeList.length > 5 ? 5 : placeList.length,
              itemBuilder: (context, index) => ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                onTap: () => onTap(placeList[index]),
                leading: const Icon(Icons.location_on, color: Colors.black),
                title: Text(placeList[index].displayName),
              ),
            );
          } else if (state is GoogleMapError) {
            return Center(child: Text(state.failure));
          }
          return Container();
        },
      ),
    );
  }
}
