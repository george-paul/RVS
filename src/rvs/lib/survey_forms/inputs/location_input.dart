import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

import '../../util.dart';
import '../survey_data.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  //
  // -------------------------------------- Location --------------------------------------
  //

  TextEditingController coordsCtl = TextEditingController();
  bool isLoadingLocation = false;

  Future<String?> getLocation() async {
    try {
      bool serviceEnabled;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Fluttertoast.showToast(msg: "Please enable location services");
        return null;
      }
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.unableToDetermine) {
        Fluttertoast.showToast(msg: "Cannot access location data");
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          Fluttertoast.showToast(msg: "Cannot access location data");
          return null;
        }
      }
      Position position = await Geolocator.getCurrentPosition().catchError((err) {
        Fluttertoast.showToast(msg: "Couldn't get your location");
        setState(() {
          isLoadingLocation = false;
        });
      });
      return "${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}";
    } catch (e) {
      redDBG(e.toString());
    }

    String? approxLoc;
    try {
      final response = await get(Uri.parse("https://geolocation-db.com/json/"));
      Map<String, dynamic> responseJson = json.decode(response.body.toString());
      approxLoc = "${responseJson["latitude"]}, ${responseJson["longitude"]}";
      Fluttertoast.showToast(msg: "Couldn't get precise location, using approximate location instead.");
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "Couldn't get location");
      return null;
    }
    return approxLoc;

    // if (!kIsWeb) {
    //   bool serviceEnabled;

    //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //   if (!serviceEnabled) {
    //     Fluttertoast.showToast(msg: "Please enable location services");
    //     return null;
    //   }
    //   LocationPermission permission;
    //   permission = await Geolocator.checkPermission();
    //   if (permission == LocationPermission.unableToDetermine) {
    //     Fluttertoast.showToast(msg: "Cannot access location data");
    //   }
    //   if (permission == LocationPermission.denied) {
    //     permission = await Geolocator.requestPermission();
    //     if (permission == LocationPermission.deniedForever) {
    //       Fluttertoast.showToast(msg: "Cannot access location data");
    //       return null;
    //     }
    //   }
    //   Position position = await Geolocator.getCurrentPosition().catchError((err) {
    //     Fluttertoast.showToast(msg: "Couldn't get your location");
    //     setState(() {
    //       isLoadingLocation = false;
    //     });
    //   });
    //   return "${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}";
    // } else {
    //   final response = await get(Uri.parse("https://geolocation-db.com/json/"));
    //   Map<String, dynamic> responseJson = json.decode(response.body.toString());
    //   return "${responseJson["latitude"]}, ${responseJson["longitude"]}";
    // }
  }

  Widget buildGetLocationButton() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          isLoadingLocation = true;
        });
        String? location = await getLocation();
        if (location != null) {
          coordsCtl.text = location;
          GetIt.I<SurveyData>().coords = coordsCtl.text;
        }
        setState(() {
          isLoadingLocation = false;
        });
      },
      child: Visibility(
        visible: !isLoadingLocation,
        replacement: SizedBox(
          width: Theme.of(context).textTheme.button!.fontSize,
          height: Theme.of(context).textTheme.button!.fontSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        child: const Text("Get Location"),
      ),
    );
  }

  TextFormField buildCoords() {
    return TextFormField(
      readOnly: true,
      controller: coordsCtl,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(Icons.location_on),
        labelText: "GPS Position",
      ),
    );
  }

  Widget buildLocationWidget() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildCoords(),
            const SizedBox(height: 20),
            buildGetLocationButton(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildLocationWidget();
  }
}
