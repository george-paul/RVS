import 'package:flutter/scheduler.dart';
import 'package:rvs/global_data.dart';

import 'survey_forms/survey_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

class SurveyCard extends StatelessWidget {
  final int surveyNumber;

  const SurveyCard({Key? key, required this.surveyNumber}) : super(key: key);

  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(20.0));

  void getItSetup() {
    GetIt.I<GlobalData>().surveyNumber = surveyNumber;
    if (GetIt.I.isRegistered<SurveyData>()) {
      GetIt.I.unregister<SurveyData>();
    }
    GetIt.I.registerSingleton<SurveyData>(SurveyData());
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/login");
      });
    }

    double imageSize = MediaQuery.of(context).size.width / 4;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () {
          getItSetup();
          Navigator.pushNamed(context, "/survey");
        },
        child: Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: imageSize,
                  width: imageSize,
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Image.asset(
                      "assets/images/surveyImage$surveyNumber.png",
                      height: imageSize,
                      width: imageSize,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${surveyTitles[surveyNumber].form}\n${surveyTitles[surveyNumber].code}",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          surveyTitles[surveyNumber].name,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SurveySelectionScreen extends StatelessWidget {
  const SurveySelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a form for the survey"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut();
              Fluttertoast.showToast(msg: "Signed Out.");
              Navigator.pushReplacementNamed(context, "/login");
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            SurveyCard(
              surveyNumber: 0,
            ),
            SurveyCard(
              surveyNumber: 1,
            ),
          ],
        ),
      ),
    );
  }
}
