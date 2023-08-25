import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../global_data.dart';
import '../../selector_widget.dart';
import '../survey_data.dart';

class StructSysInput extends StatefulWidget {
  const StructSysInput({super.key});

  @override
  State<StructSysInput> createState() => _StructSysInputState();
}

class _StructSysInputState extends State<StructSysInput> {
  int surveyNumber = 0;

  @override
  initState() {
    surveyNumber = GetIt.I<GlobalData>().surveyNumber;
    selectedStructSys = List.generate(structSysOptions[surveyNumber].length, (index) => false);
    super.initState();
  }

  //
  // ----------------------------- Struct Sys Selector -----------------------------
  //

  TextEditingController otherStructSysCtl = TextEditingController();
  List<bool> selectedStructSys = [];

  buildStructSys() {
    return Column(
      children: [
        SelectorWidget(
          title: "Structural System",
          selectedCheckboxes: selectedStructSys,
          options: structSysOptions[surveyNumber],
          otherCtl: otherStructSysCtl,
          updateCallback: (updatedString) {
            GetIt.I<SurveyData>().structSys = updatedString;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildStructSys();
  }
}
