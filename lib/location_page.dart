import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Position? _currentPosition;
  String? _currentAdress;

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission(context);

    if (!hasPermission) {
      return;
    }

    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((value) {
      _currentPosition = value;
      if (_currentPosition != null) {
        getAddressByLatLong(_currentPosition!);
      }
      setState(() {});
    });
  }

  Future<void> getAddressByLatLong(Position position) async {
    final resultAdress = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark placemark = resultAdress.first;

    _currentAdress =
        '${placemark.street} ${placemark.subLocality} ${placemark.subAdministrativeArea} ${placemark.postalCode}';
    setState(() {});
  }

  @override
  void initState() {
    getCurrentPosition();
    super.initState();
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Lokasi tidak di aktifkan, silahkan aktifkan terlebih dahulu',
            ),
          ),
        );
      }
      return false;
    }

    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ijin Lokasi di tolak',
            ),
          ),
        );
      }
      return false;
    }

    if (locationPermission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Ijin Lokasi di tolak secara permanent, silahkan aktifkan lewat hp anda langsung',
            ),
          ),
        );
      }
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lokasi Saya',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Lat: ${_currentPosition?.latitude ?? "-"}'),
            Text('Lang: ${_currentPosition?.longitude ?? "-"} '),
            Text('Address : ${_currentAdress ?? "-"}'),
            ElevatedButton(
              onPressed: getCurrentPosition,
              child: const Text(
                'Get Lokasi',
              ),
            )
          ],
        ),
      ),
    );
  }
}
