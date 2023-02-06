import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:rvs/survey01_forms/survey01_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import '../camera_screen.dart';
import '../util.dart';

class S01BuildingDescriptionForm extends StatefulWidget {
  const S01BuildingDescriptionForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _S01BuildingDescriptionFormState createState() => _S01BuildingDescriptionFormState();
}

class _S01BuildingDescriptionFormState extends State<S01BuildingDescriptionForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static const BorderRadius borderRadiusCached = BorderRadius.all(Radius.circular(20.0));

  //
  // -------------------------------------- Number of Storeys --------------------------------------
  //
  TextEditingController buildingNameCtl = TextEditingController();
  TextEditingController addressLine1Ctl = TextEditingController();
  TextEditingController addressLine2Ctl = TextEditingController();
  TextEditingController addressCityTownCtl = TextEditingController();

  Widget buildBuildingAddress() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: borderRadiusCached),
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
                GetIt.I<Survey01Data>().buildingName = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: buildingNameCtl,
            ),
            SizedBox(height: 22.0),
            Text(
              "Address Line 1",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (val) {
                GetIt.I<Survey01Data>().addressLine1 = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: addressLine1Ctl,
            ),
            SizedBox(height: 22.0),
            Text(
              "Address Line 2",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (val) {
                GetIt.I<Survey01Data>().addressLine2 = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: addressLine2Ctl,
            ),
            SizedBox(height: 22.0),
            Text(
              "City/Town",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (val) {
                GetIt.I<Survey01Data>().addressCityTown = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // hintText: "Enter a number",
              ),
              controller: addressCityTownCtl,
            ),
          ],
        ),
      ),
    );
  }

  //
  // -------------------------------------- Views Of Structure --------------------------------------
  //
  void takeStructureViewPicture(int index) async {
    File? imgFile;
    try {
      imgFile = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CameraPage(),
        ),
      ).catchError((e) {
        Fluttertoast.showToast(msg: "Could not take picture");
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not take picture");
      return;
    }
    if (imgFile == null) {
      Fluttertoast.showToast(msg: "Did not save picture");
      return;
    }
    Directory appDocDir = await getApplicationDocumentsDirectory();
    await imgFile.copy("${appDocDir.path}/StructureView${index.toString()}");

    GetIt.I<Survey01Data>().picturesTaken[index] = true;
    setState(() {
      hasTakenPicture[index] = true;
    });
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

  //--------------------------    T      L      R      B
  List<bool> hasTakenPicture = [false, false, false, false];

  Widget buildViewsOfStructure() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: borderRadiusCached),
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
  // -------------------------------------- Occupancy --------------------------------------
  //
  List<Pair<bool, String>> occupancyOptions = [
    Pair(false, "Residential"),
    Pair(false, "Educational"),
    Pair(false, "Lifeline"),
    Pair(false, "Commercial"),
    Pair(false, "Office"),
    Pair(false, "Mixed Use"),
    Pair(false, "Industrial"),
    Pair(false, "Other"),
  ];
  int? selectedOccupancy;
  String selectedOccupancyString = "";

  Widget buildOccupancySelector() {
    return ExpansionTileCard(
      borderRadius: borderRadiusCached.bottomLeft.x, // equates to the .all.circular's value
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        title: Text(
          "Occupancy",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          (selectedOccupancy != null) ? occupancyOptions[selectedOccupancy!].b : "None",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List.generate(occupancyOptions.length, (index) {
          return RadioListTile(
            title: Text(occupancyOptions[index].b),
            groupValue: selectedOccupancy,
            value: index,
            onChanged: (val) {
              GetIt.I<Survey01Data>().occupancy = val as int;
              GetIt.I<Survey01Data>().occupancyString = occupancyOptions[val].b;
              GetIt.I<Survey01Data>().subOccupancy = null;
              GetIt.I<Survey01Data>().subOccupancyString = null;
              setState(() {
                selectedOccupancy = val;
                selectedOccupancyString = occupancyOptions[selectedOccupancy!].b;
                selectedSubOccupancy = null;
                selectedSubOccupancyString = "";
              });
            },
          );
        }),
      ),
    );
  }

  //
  // -------------------------------------- Sub Occupancy --------------------------------------
  //

  List<List<Pair<bool, String>>> subOccupancyOptions = [
    [
      Pair(false, "Individual House"),
      Pair(false, "Apartments"),
    ],
    [
      Pair(false, "School"),
      Pair(false, "College"),
      Pair(false, "Institute/University"),
    ],
    [
      Pair(false, "Hospital"),
      Pair(false, "Police Station"),
      Pair(false, "Fire Station"),
      Pair(false, "Power Station"),
      Pair(false, "Water Plant"),
      Pair(false, "SewagePlant"),
    ],
    [
      Pair(false, "Hotel"),
      Pair(false, "Shopping"),
      Pair(false, "Recreational"),
    ],
    [
      Pair(false, "Government"),
      Pair(false, "Private"),
    ],
    [
      Pair(false, "Residential and Commercial"),
      Pair(false, "Residential and Industrial"),
    ],
    [
      Pair(false, "Agriculture"),
      Pair(false, "Livestock"),
    ],
    [/* other */],
  ];
  int? selectedSubOccupancy;
  String selectedSubOccupancyString = "";

  buildSubOccupancySelector() {
    return Visibility(
      visible: (selectedOccupancy != null),
      replacement: Container(),
      child: ExpansionTileCard(
        borderRadius: borderRadiusCached.bottomLeft.x, // equates to the .all.circular's value
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(20),
          title: Text(
            "Select $selectedOccupancyString Occupancy",
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              (selectedSubOccupancy != null)
                  ? subOccupancyOptions[selectedOccupancy ?? 0][selectedSubOccupancy!].b
                  : "None",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          children: List.generate(subOccupancyOptions[selectedOccupancy ?? 0].length, (index) {
            return RadioListTile(
              title: Text(subOccupancyOptions[selectedOccupancy ?? 0][index].b),
              groupValue: selectedSubOccupancy,
              value: index,
              onChanged: (val) {
                GetIt.I<Survey01Data>().subOccupancy = val as int;
                GetIt.I<Survey01Data>().subOccupancyString = subOccupancyOptions[selectedOccupancy!][val].b;
                setState(() {
                  selectedSubOccupancy = val;
                  selectedSubOccupancyString = subOccupancyOptions[selectedOccupancy!][val].b;
                });
              },
            );
          }),
        ),
      ),
    );
  }

  //
  // -------------------------------------- Build --------------------------------------
  //

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildBuildingAddress(),
            const SizedBox(height: 20),
            buildViewsOfStructure(),
            const SizedBox(height: 20),
            buildOccupancySelector(),
            const SizedBox(height: 20),
            buildSubOccupancySelector(),
          ],
        ),
      ),
    );
  }
}