import 'package:flutter/scheduler.dart';
import 'package:rvs/vulnerability_element.dart';

import './global_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'survey_forms/survey_data.dart';
import 'survey_forms/survey_export.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  List<Widget> tabViews = [];
  List<String> tabTitles = [];

  List<Tab> tabs = [];
  int surveyNumber = 0;

  @override
  void initState() {
    if (!GetIt.I.isRegistered<SurveyData>()) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/survey_selection");
      });
    }

    tabViews = [
      // const InspectorDetailsForm(),
      const BuildingDescriptionForm(),
      // const StructSysForm(),
      // const StructComponentsForm(),
      // const OccupancyForm(),
      // const VulnerabilityForm(),
      const SuggestionForm(),
      const SubmitForm(),
    ];
    tabTitles = [
      // "Inspector Details",
      "Building Description",
      // "Structural System",
      // "Structural Components",
      // "Occupancy",
      // "Vulnerability",
      "Suggestions",
      "Submit",
    ];

    tabs = List.generate(tabViews.length, (index) {
      return Tab(
        text: tabTitles[index],
      );
    });

    surveyNumber = GetIt.I<GlobalData>().surveyNumber;
    List<VulnElement> vulnElements = getFormVulnElements(possibleElements, surveyNumber);
    GetIt.I<SurveyData>().vulnCheckboxes.addAll(List.filled(vulnElements.length, null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // this widget is so that the user can't close camera with back button
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
              title: Text(surveyTitles[surveyNumber].surveyScreenTitle),
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
