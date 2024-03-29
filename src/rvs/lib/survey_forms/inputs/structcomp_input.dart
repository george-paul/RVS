import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rvs/subheading_widget.dart';
import 'package:rvs/survey_forms/survey_data.dart';

import '../../global_data.dart';
import '../../linedheading_widget.dart';
import '../../selector_widget.dart';

class StructCompInput extends StatefulWidget {
  const StructCompInput({super.key});

  @override
  State<StructCompInput> createState() => _StructCompInputState();
}

class _StructCompInputState extends State<StructCompInput> {
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

  static const int l1rcNumber = 1;

  TextEditingController otherRoofGeoCtl = TextEditingController();
  List<bool> selectedRoofGeo = [];

  //
  // ----------------------------- Mortar Selector -----------------------------
  //

  TextEditingController otherMortarCtl = TextEditingController();
  List<bool> selectedMortar = [];

  buildStructComp() {
    return Column(
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
        if (surveyNumber != l1rcNumber)
          SubHeading(
            label: "Roof System",
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  // fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
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
          title: (surveyNumber != l1rcNumber) ? "Roof Geometry" : "Roof System",
          selectedCheckboxes: selectedRoofGeo,
          options: roofGeoOptions[surveyNumber],
          otherCtl: otherRoofGeoCtl,
          updateCallback: (updatedString) {
            GetIt.I<SurveyData>().roofGeo = updatedString;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildStructComp();
  }
}
