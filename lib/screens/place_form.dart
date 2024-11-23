import 'dart:io';

import 'package:favorite_places_app/models/place.model.dart';
import 'package:favorite_places_app/models/place_location.model.dart';
import 'package:favorite_places_app/providers/places_provider.dart';
import 'package:favorite_places_app/widgets/image_input.dart';
import 'package:favorite_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceFormScreen extends ConsumerStatefulWidget {
  const PlaceFormScreen({super.key});

  @override
  ConsumerState<PlaceFormScreen> createState() {
    return _PlaceFormScreenState();
  }
}

class _PlaceFormScreenState extends ConsumerState<PlaceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _inputTitle = "";
  late File _inputImage;
  late PlaceLocation _inputLocation;

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    ref.read(placesProviderNotifier.notifier).updatePlaces(
          Place(
            name: _inputTitle,
            image: _inputImage,
            location: _inputLocation,
          ),
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add a Place",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  label: Text(
                    "Title",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter a title, field is required";
                  }
                  if (value.trim().length <= 2) {
                    return "Title must at least consists of 3 letters";
                  }
                  return null;
                },
                maxLength: 50,
                onChanged: (value) => _inputTitle = value,
              ),
              const SizedBox(height: 16),
              ImageInput(
                onPickImage: (image) => _inputImage = image,
              ),
              const SizedBox(height: 16),
              LocationInput(
                onSelectLocation: (location) => _inputLocation = location,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style,
                onPressed: _submitForm,
                child: Text(
                  "Submit",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
