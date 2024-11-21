import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places_app/models/place.model.dart';

class PlacesProvider extends StateNotifier<List<Place>> {
  PlacesProvider() : super(const []);

  void updatePlaces(Place newPlace) {
    state = [newPlace, ...state];
  }
}

final placesProviderNotifier =
    StateNotifierProvider<PlacesProvider, List<Place>>(
  (ref) => PlacesProvider(),
);
