import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rvs/global_data.dart';
import 'package:rvs/survey01_forms/survey01_data.dart';
import 'package:rvs/vulnerability_data.dart';

class CalculationForm extends StatefulWidget {
  const CalculationForm({Key? key}) : super(key: key);

  @override
  CalculationFormState createState() => CalculationFormState();
}

class CalculationFormState extends State<CalculationForm> with AutomaticKeepAliveClientMixin {
  static const BorderRadius borderRadiusCached = BorderRadius.all(Radius.circular(20.0));

  bool calcDone = false;
  String colorRating = "";
  Color colorRatingColor = Colors.red;
  bool isLoading = false;

  @override
  bool get wantKeepAlive => true;

  void doRatingCalculation() {
    // reset
    GetIt.I<Survey01Data>().suggestedInterventions = "";
    suggIntCtl.text = "";

    List<bool> lifeCheckboxes = GetIt.I<Survey01Data>().lifeCheckboxes;
    List<bool> ecoCheckboxes = GetIt.I<Survey01Data>().ecoCheckboxes;
    int surveyNumber = GetIt.I<GlobalData>().surveyNumber;

    List<VulnElement> lifeElements = getFormVulnElements(possibleLifeThreatening, surveyNumber);
    List<List<String>> tempRows = [[], [], []];
    for (int i = 0; i < lifeElements.length; i++) {
      VulnElement ele = lifeElements[i];
      if (ele.runtimeType == VulnQuestion) {
        ele = ele as VulnQuestion;
        if (lifeCheckboxes[i]) {
          tempRows[ele.color.index].add(ele.text);
        }
      }
    }

    List<VulnElement> ecoElements = getFormVulnElements(possibleEconomicLoss, surveyNumber);
    for (int i = 0; i < ecoElements.length; i++) {
      VulnElement ele = ecoElements[i];
      if (ele.runtimeType == VulnQuestion) {
        ele = ele as VulnQuestion;
        if (ecoCheckboxes[i]) {
          tempRows[ele.color.index].add(ele.text);
        }
      }
    }

    if (tempRows[0].isNotEmpty) {
      colorRating = "Red";
      colorRatingColor = Colors.red;
    } else if (tempRows[1].isNotEmpty) {
      colorRating = "Yellow";
      colorRatingColor = Colors.yellow;
    } else {
      colorRating = "Green";
      colorRatingColor = Colors.green;
    }

    setState(() {
      calcDone = true;
    });
    GetIt.I<Survey01Data>().calcDone = true;
  }

  Widget buildRatingDisplay() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "This structure has a colour rating of: ",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            colorRating,
            style: Theme.of(context).textTheme.headline6!.copyWith(color: colorRatingColor),
          ),
        ],
      ),
    );
  }

  final TextEditingController suggIntCtl = TextEditingController();

  Widget buildSuggestedInterventions() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: borderRadiusCached),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Suggested Interventions",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (val) {
                GetIt.I<Survey01Data>().suggestedInterventions = val.trim();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              controller: suggIntCtl,
            ),
          ],
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
            const SizedBox(height: 40),
            const Text(
              "Click the button below to calculate the color rating for this structure.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                doRatingCalculation();
              },
              child: Visibility(
                visible: isLoading,
                replacement: const Text("Calculate"),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                  child: SizedBox(
                    height: Theme.of(context).textTheme.labelLarge?.fontSize,
                    width: Theme.of(context).textTheme.labelLarge?.fontSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            if (calcDone) buildRatingDisplay(),
            const SizedBox(height: 20),
            if (calcDone && colorRating == "Yellow") buildSuggestedInterventions(),
          ],
        ),
      ),
    );
  }
}
