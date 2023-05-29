import 'package:rvs/global_data.dart';
import 'package:rvs/survey_forms/survey_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../selector_widget.dart';

class StructSysForm extends StatefulWidget {
  const StructSysForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StructSysFormState createState() => _StructSysFormState();
}

class _StructSysFormState extends State<StructSysForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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

  //
  // ----------------------------- build -----------------------------
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
              title: "Structural System",
              selectedCheckboxes: selectedStructSys,
              options: structSysOptions[surveyNumber],
              otherCtl: otherStructSysCtl,
              updateCallback: (updatedString) {
                GetIt.I<SurveyData>().structSys = updatedString;
              },
            ),
          ],
        ),
      ),
    );
  }
}
