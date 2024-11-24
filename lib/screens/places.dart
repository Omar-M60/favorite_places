import 'package:favorite_places_app/providers/places_provider.dart';
import 'package:favorite_places_app/screens/place_details.dart';
import 'package:favorite_places_app/screens/place_form.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesState();
  }
}

class _PlacesState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    _placesFuture = ref.read(placesProviderNotifier.notifier).loadPlaces();
    super.initState();
  }

  void _addPlaceItem() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const PlaceFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProviderNotifier);

    Widget currentDisplay = Center(
      child: Text(
        "No places added...",
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );

    if (places.isNotEmpty) {
      currentDisplay = ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(places[index].image),
          ),
          title: Text(places[index].name),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PlaceDetailsScreen(
                  place: places[index],
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Places",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: _addPlaceItem,
            icon: const Icon(Icons.add),
          ),
        ],
        actionsIconTheme: Theme.of(context).appBarTheme.iconTheme,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  )
                : currentDisplay,
      ),
    );
  }
}
