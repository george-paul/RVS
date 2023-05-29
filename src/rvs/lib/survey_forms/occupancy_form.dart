import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rvs/survey_forms/survey_data.dart';
import 'package:rvs/util.dart';

class OccupancyForm extends StatefulWidget {
  const OccupancyForm({Key? key}) : super(key: key);

  @override
  OccupancyFormState createState() => OccupancyFormState();
}

class OccupancyFormState extends State<OccupancyForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Pair<bool, String>> occupancyOptions = [
    Pair(false, "Residential"),
    Pair(false, "Educational"),
    Pair(false, "Lifeline"),
    Pair(false, "Commercial"),
    Pair(false, "Office"),
    Pair(false, "Mixed Use"),
    Pair(false, "Other"),
  ];
  int? selectedOccupancy;
  String selectedOccupancyString = "";

  Widget buildOccupancySelector() {
    return ExpansionTileCard(
      borderRadius: cardBorderRadius.bottomLeft.x, // equates to the .all.circular's value
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
              GetIt.I<SurveyData>().occupancy = val as int;
              GetIt.I<SurveyData>().occupancyString = occupancyOptions[val].b;
              GetIt.I<SurveyData>().subOccupancy = null;
              GetIt.I<SurveyData>().subOccupancyString = null;
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
      Pair(false, "Residential-Commercial"),
      Pair(false, "Residential-Industrial"),
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
        borderRadius: cardBorderRadius.bottomLeft.x, // equates to the .all.circular's value
        child: ExpansionTile(
          initiallyExpanded: true,
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
                GetIt.I<SurveyData>().subOccupancy = val as int;
                GetIt.I<SurveyData>().subOccupancyString = subOccupancyOptions[selectedOccupancy!][val].b;
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

  TextEditingController otherOccupancyCtl = TextEditingController();

  buildOtherOccupancyField() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          onChanged: (val) {
            setState(() {}); // rebuilds tile subtitle
            GetIt.I<SurveyData>().otherOccupancyString = val;
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Others (overwrites the above selector)",
          ),
          controller: otherOccupancyCtl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            buildOccupancySelector(),
            const SizedBox(height: 20),
            buildSubOccupancySelector(),
            const SizedBox(height: 20),
            buildOtherOccupancyField(),
          ],
        ),
      ),
    );
  }
}
