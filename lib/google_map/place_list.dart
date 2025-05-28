import 'package:flutter/material.dart';
import 'place.dart';

class PlaceList extends StatelessWidget {
  final List<Place> places;
  final void Function(Place) onTap;
  final Place? selected;

  const PlaceList({
    super.key,
    required this.places,
    required this.onTap,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const Center(child: Text('검색 결과가 없습니다.'));
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        final isSelected = selected == place;
        return ListTile(
          selected: isSelected,
          title: Text(place.name),
          subtitle: Text(place.address),
          onTap: () => onTap(place),
        );
      },
    );
  }
}
