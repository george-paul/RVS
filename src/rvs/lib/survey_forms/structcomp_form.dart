import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rvs/survey_forms/survey_data.dart';

import '../global_data.dart';
import '../selector_widget.dart';

class StructComponentsForm extends StatefulWidget {
  const StructComponentsForm({Key? key}) : super(key: key);

  @override
  StructComponentsFormState createState() => StructComponentsFormState();
}

class StructComponentsFormState extends State<StructComponentsForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int surveyNumber = 0;

  @override
  initState() {
    surveyNumber = GetIt.I<GlobalData>().surveyNumber;

    selectedFloor = List.generate(floorOptions[surveyNumber].length, (index) => false);
    selectedRoofGeo = List.generate(roofGeoOptions[surveyNumber].length, (index) => false);
    selectedRoofMat = List.generate(roofMatOptions[surveyNumber].length, (index) => false);
    selectedMortar = List.generate(mortarOptions[surveyNumber].length, (index) => false);

    super.initState();
  }

  //
  // ----------------------------- Floor Selector -----------------------------
  //

  TextEditingController otherFloorCtl = TextEditingController();
  List<bool> selectedFloor = [];

  //
  // ----------------------------- Roof Mat Selector -----------------------------
  //

  TextEditingController otherRoofMatCtl = TextEditingController();
  List<bool> selectedRoofMat = [];

  //
  // ----------------------------- Roof Geo Selector -----------------------------
  //

  TextEditingController otherRoofGeoCtl = TextEditingController();
  List<bool> selectedRoofGeo = [];

  //
  // ----------------------------- Mortar Selector -----------------------------
  //

  TextEditingController otherMortarCtl = TextEditingController();
  List<bool> selectedMortar = [];

  //
  // ----------------------------- Build -----------------------------
  //

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SelectorWidget(
              title: "Floor System",
              selectedCheckboxes: selectedFloor,
              options: floorOptions[surveyNumber],
              otherCtl: otherFloorCtl,
              updateCallback: (updatedString) {
                GetIt.I<SurveyData>().floor = updatedString;
              },
            ),
            if (mortarOptions[surveyNumber].isNotEmpty) const SizedBox(height: 20),
            if (mortarOptions[surveyNumber].isNotEmpty)
              SelectorWidget(
                title: "Wall Masonry Mortar",
                selectedCheckboxes: selectedMortar,
                options: mortarOptions[surveyNumber],
                otherCtl: otherMortarCtl,
                updateCallback: (updatedString) {
                  GetIt.I<SurveyData>().mortar = updatedString;
                },
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 40.0, 20.0, 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Roof System", style: Theme.of(context).textTheme.headline5),
              ),
            ),
            if (roofMatOptions[surveyNumber].isNotEmpty)
              SelectorWidget(
                title: "Roof Material",
                selectedCheckboxes: selectedRoofMat,
                options: roofMatOptions[surveyNumber],
                otherCtl: otherRoofMatCtl,
                updateCallback: (updatedString) {
                  GetIt.I<SurveyData>().roofMat = updatedString;
                },
              ),
            const SizedBox(height: 20),
            SelectorWidget(
              title: "Roof Geometry",
              selectedCheckboxes: selectedRoofGeo,
              options: roofGeoOptions[surveyNumber],
              otherCtl: otherRoofGeoCtl,
              updateCallback: (updatedString) {
                GetIt.I<SurveyData>().roofGeo = updatedString;
              },
            ),
          ],
        ),
      ),
    );
  }
}
