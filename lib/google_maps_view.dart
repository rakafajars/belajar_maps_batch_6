import 'dart:async';

import 'package:belajar_google_maps_batch_6/const/api_key.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class GoogleMapsView extends StatefulWidget {
  const GoogleMapsView({super.key});

  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<GoogleMapsView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  TextEditingController mapsSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: mapsSearchController,
              googleAPIKey: apiKey,
              inputDecoration: const InputDecoration(),
              debounceTime: 800,
              countries: const [
                "id",
              ],
              itemClick: (prediction) {
                currentLocation(
                  newLat: -6.921545681619832,
                  newLng: 107.74389851736683,
                );
              },
            ),
          ),
          // TextFormField(
          //   onChanged: (value) async {
          //     final p = await PlacesAutocomplete.show(
          //       context: context,
          //       apiKey: apiKey,
          //       mode: Mode.overlay,
          //       language: "en",
          //       decoration: InputDecoration()
          //     );
          //   },
          // ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                  -6.94811989228639,
                  107.70360292542077,
                ),
                zoom: 16,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: {
                const Marker(
                  markerId: MarkerId(
                    'Indonesia',
                  ),
                  position: LatLng(
                    -6.94811989228639,
                    107.70360292542077,
                  ),
                ),
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          currentLocation();
        },
        child: const Icon(
          Icons.male_sharp,
        ),
      ),
    );
  }

  void currentLocation({double? newLat, double? newLng}) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            newLat ?? -6.94811989228639,
            newLng ?? 107.70360292542077,
          ),
          zoom: 16,
        ),
      ),
    );
  }
}
