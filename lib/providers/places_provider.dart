import 'dart:io';

import 'package:favorite_places_app/models/place_location.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:favorite_places_app/models/place.model.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places (id TEXT PRIMARY KEY, name TEXT, image TEXT, lng REAL, lat REAL, address TEXT)',
      );
    },
    version: 1,
  );
  return db;
}

class PlacesProvider extends StateNotifier<List<Place>> {
  PlacesProvider() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            name: row['name'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              address: row['address'] as String,
              lat: row['lat'] as double,
              lng: row['lng'] as double,
            ),
          ),
        )
        .toList();

    state = places;
  }

  void updatePlaces(Place newPlace) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final filename = path.basename(newPlace.image.path);
    final copiedImage = await newPlace.image.copy('${appDir.path}/$filename');

    newPlace.setImage = copiedImage;

    final db = await _getDatabase();
    db.insert(
      'user_places',
      {
        'id': newPlace.id,
        'name': newPlace.name,
        'image': newPlace.image.path,
        'lng': newPlace.location.lng,
        'lat': newPlace.location.lat,
        'address': newPlace.location.address,
      },
    );

    state = [newPlace, ...state];
  }
}

final placesProviderNotifier =
    StateNotifierProvider<PlacesProvider, List<Place>>(
  (ref) => PlacesProvider(),
);
