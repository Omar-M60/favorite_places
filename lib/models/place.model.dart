import 'dart:io';

import 'package:favorite_places_app/models/place_location.model.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({
    required this.name,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String name;
  File image;
  final PlaceLocation location;

  set setImage(File newImage) {
    image = newImage;
  }
}
