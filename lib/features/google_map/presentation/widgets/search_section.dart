import 'package:flutter/material.dart';
import 'package:routing_tracker/features/google_map/presentation/widgets/custom_text_field.dart';
import 'package:routing_tracker/features/google_map/presentation/widgets/search_list.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  late TextEditingController _searchController;

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
        CustomTextField(controller: _searchController),
        const SizedBox(height: 12),
        SearchList(),
      ],
    );
  }
}
