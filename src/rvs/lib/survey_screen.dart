import 'package:rvs/vulnerability_data.dart';

import './global_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'survey01_forms/survey01_data.dart';
import 'survey01_forms/survey01_export.dart';

class SurveyScreen extends StatefulWidget {
  final int surveyNumber;

  const SurveyScreen({Key? key, required this.surveyNumber}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  List<Widget> tabViews = [];
  List<String> tabTitles = [];

  List<Tab> tabs = [];

  @override
  void initState() {
    tabViews = [
      const S01InspectorDetailsForm(),
      const S01BuildingDescriptionForm(),
      const S01StructSysForm(),
      const S01VulnerabilityForm(),
      const CalculationForm(),
      const FurtherActionsForm(),
      const S01SubmitForm(),
    ];
    tabTitles = [
      "Inspector Details",
      "Building Description",
      "Structural System and Components",
      "Vulnerability",
      "Calculation",
      "Further Actions",
      "Submit",
    ];

    tabs = List.generate(tabViews.length, (index) {
      return Tab(
        text: tabTitles[index],
      );
    });

    int surveyNumber = GetIt.I<GlobalData>().surveyNumber;
    List<VulnElement> lifeFormVulnElements = getFormVulnElements(possibleLifeThreatening, surveyNumber);
    GetIt.I<Survey01Data>().lifeCheckboxes.addAll(List.filled(lifeFormVulnElements.length, false));
    List<VulnElement> ecoFormVulnElements = getFormVulnElements(possibleEconomicLoss, surveyNumber);
    GetIt.I<Survey01Data>().ecoCheckboxes.addAll(List.filled(ecoFormVulnElements.length, false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (GetIt.I<GlobalData>().cameraOpen) {
          return false;
        } else {
          return true;
        }
      },
      child: DefaultTabController(
        length: tabs.length,
        child: Builder(builder: (context) {
          // close keyboard on tab change
          final TabController tabController = DefaultTabController.of(context)!;
          tabController.addListener(() {
            FocusManager.instance.primaryFocus?.unfocus();
          });

          // build
          return Scaffold(
            appBar: AppBar(
              title: Text("RVS - ${surveyTitles[widget.surveyNumber]}"),
              bottom: TabBar(
                isScrollable: true,
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              children: tabViews,
            ),
          );
        }),
      ),
    );
  }
}
