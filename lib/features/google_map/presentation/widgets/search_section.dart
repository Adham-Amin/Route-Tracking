import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routing_tracker/features/google_map/presentation/cubit/google_map_cubit.dart';
import 'package:routing_tracker/features/google_map/presentation/widgets/custom_text_field.dart';
import 'package:routing_tracker/features/google_map/presentation/widgets/search_list.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  late TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: _searchController,
          onChanged: (value) {
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 300), () {
              context.read<GoogleMapCubit>().getPlaces(query: value);
            });
          },
        ),
        const SizedBox(height: 12),
        SearchList(
          onTap: (place) {
            _searchController.clear();
            context.read<GoogleMapCubit>().clearPlaces();
            log(place.lat.toString());
            log(place.lon.toString());
          },
        ),
      ],
    );
  }
}
