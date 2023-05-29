import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rvs/survey_forms/survey_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:rvs/util.dart';

class BuildingDescriptionForm extends StatefulWidget {
  const BuildingDescriptionForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BuildingDescriptionFormState createState() => _BuildingDescriptionFormState();
}

class _BuildingDescriptionFormState extends State<BuildingDescriptionForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  //
  // -------------------------------------- Location --------------------------------------
  //

  TextEditingController coordsCtl = TextEditingController();
  bool isLoadingLocation = false;

  Future<String?> getLocation() async {
    if (!kIsWeb) {
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
    } else {
      final response = await get(Uri.parse("https://geolocation-db.com/json/"));
      Map<String, dynamic> responseJson = json.decode(response.body.toString());
      return "${responseJson["latitude"]}, ${responseJson["longitude"]}";
    }
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

  //
  // -------------------------------------- Building Address --------------------------------------
  //
  TextEditingController buildingNameCtl = TextEditingController();
  TextEditingController addressLine1Ctl = TextEditingController();
  TextEditingController addressLine2Ctl = TextEditingController();
  TextEditingController addressCityTownCtl = TextEditingController();
  TextEditingController addressCountryCtl = TextEditingController(text: "India");

  Widget buildBuildingAddress() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Building Name",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (val) {
                GetIt.I<SurveyData>().buildingName = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: buildingNameCtl,
            ),
            const SizedBox(height: 22.0),
            Text(
              "Address Line 1",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (val) {
                GetIt.I<SurveyData>().addressLine1 = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: addressLine1Ctl,
            ),
            const SizedBox(height: 22.0),
            Text(
              "Address Line 2",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (val) {
                GetIt.I<SurveyData>().addressLine2 = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: addressLine2Ctl,
            ),
            const SizedBox(height: 22.0),
            Text(
              "City/Town",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (val) {
                GetIt.I<SurveyData>().addressCityTown = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: addressCityTownCtl,
            ),
            const SizedBox(height: 22.0),
            Text(
              "Country",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              readOnly: true,
              onTap: () {
                showCountryPicker(
                  context: context,
                  onSelect: (country) {
                    setState(() {
                      addressCountryCtl.text = country.name;
                    });
                    GetIt.I<SurveyData>().addressCountry = country.name.trim();
                  },
                );
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: addressCountryCtl,
            ),
          ],
        ),
      ),
    );
  }

  //
  // -------------------------------------- Views Of Structure --------------------------------------
  //

  // call with index == -1 to take an extra picture
  void takeStructureViewPicture(int index) async {
    final XFile? xImg = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xImg == null) {
      Fluttertoast.showToast(msg: "Did not take image");
      return;
    }

    // for non FLRB pictures
    if (index == -1) {
      GetIt.I<SurveyData>().pictures.add(null);
      index = extraPictureNumber + 4;
    }

    GetIt.I<SurveyData>().pictures[index] = xImg;

    if (index <= 3) {
      GetIt.I<SurveyData>().picturesTaken[index] = true;
      setState(() {
        hasTakenPicture[index] = true;
      });
    } else {
      // extra picture
      GetIt.I<SurveyData>().extraPicturesNumber++;
      setState(() {
        extraPictureNumber++;
      });
    }
  }

  Widget cameraButtonIcon({required bool isTicked}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.camera_alt),
        Align(
          alignment: Alignment.bottomRight,
          child: Visibility(
            visible: isTicked,
            child: const Icon(
              Icons.done,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  //                              T      L      R      B
  List<bool> hasTakenPicture = [false, false, false, false];

  Widget buildViewsOfStructure() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Views of the Structure", style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    takeStructureViewPicture(0);
                  },
                  icon: cameraButtonIcon(isTicked: hasTakenPicture[0]),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    takeStructureViewPicture(1);
                  },
                  icon: cameraButtonIcon(isTicked: hasTakenPicture[1]),
                ),
                const Icon(
                  Icons.business_outlined,
                  size: 54,
                ),
                IconButton(
                  onPressed: () {
                    takeStructureViewPicture(2);
                  },
                  icon: cameraButtonIcon(isTicked: hasTakenPicture[2]),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    takeStructureViewPicture(3);
                  },
                  icon: cameraButtonIcon(isTicked: hasTakenPicture[3]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //
  // -------------------------------------- Extra Pictures --------------------------------------
  //

  int extraPictureNumber = 0;

  Widget buildExtraPictures() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text("Number of extra views added: ", style: Theme.of(context).textTheme.headline6),
                ),
                const SizedBox(width: 20),
                Text(extraPictureNumber.toString(), style: Theme.of(context).textTheme.headline6),
                const SizedBox(width: 60),
                FloatingActionButton(
                  onPressed: () {
                    takeStructureViewPicture(-1);
                  },
                  child: const Icon(Icons.camera_enhance_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //
  // -------------------------------------- Build --------------------------------------
  //

  @override
  Widget build(BuildContext context) {
    extraPictureNumber = GetIt.I<SurveyData>().extraPicturesNumber;
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
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
            ),
            const SizedBox(height: 20),
            buildBuildingAddress(),
            const SizedBox(height: 20),
            buildViewsOfStructure(),
            const SizedBox(height: 20),
            buildExtraPictures(),
          ],
        ),
      ),
    );
  }
}
