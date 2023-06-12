import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rvs/actionbutton_widget.dart';
import 'package:rvs/survey_forms/survey_data.dart';
import 'package:rvs/util.dart';

class SuggestionForm extends StatefulWidget {
  const SuggestionForm({Key? key}) : super(key: key);

  @override
  SuggestionFormState createState() => SuggestionFormState();
}

class SuggestionFormState extends State<SuggestionForm> with AutomaticKeepAliveClientMixin {
  bool calcDone = false;
  String colorRating = "";
  Color colorRatingColor = Colors.red;
  bool isLoading = false;

  @override
  bool get wantKeepAlive => true;

  final TextEditingController suggIntCtl = TextEditingController();

  Widget buildSuggestedInterventions() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
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
                GetIt.I<SurveyData>().suggestedInterventions = val.trim();
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

  //
  // -------------------------------------- Extra Pictures --------------------------------------
  //

  void takeSuggScanPicture() async {
    final XFile? xImg = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xImg == null) {
      Fluttertoast.showToast(msg: "Did not take image");
      return;
    }

    GetIt.I<SurveyData>().suggScansPictures.add(null);
    GetIt.I<SurveyData>().suggScansPictures[suggScansNumber] = xImg;

    GetIt.I<SurveyData>().suggScansPicturesNumber++;
    setState(() {
      suggScansNumber++;
    });
  }

  int suggScansNumber = 0;

  Widget buildScanPictures() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text("Number of scans added: ", style: Theme.of(context).textTheme.headline6),
                ),
                const SizedBox(width: 20),
                Text(suggScansNumber.toString(), style: Theme.of(context).textTheme.headline6),
                const SizedBox(width: 60),
                ActionButton(
                  onPressed: () {
                    takeSuggScanPicture();
                  },
                  icon: const Icon(Icons.camera_enhance_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //
  // ----------------------------- Further Actions -----------------------------
  //

  bool buildingToBeSealed = false;
  bool buildingToBeDemolished = false;

  Widget radioButtonGroup(bool sealedGroup) {
    bool? groupVal;
    if (sealedGroup) {
      groupVal = GetIt.I<SurveyData>().buildingToBeSealed;
    } else {
      groupVal = GetIt.I<SurveyData>().buildingToBeDemolished;
    }

    void Function(bool?) onChanged = (val) {
      if (sealedGroup) {
        GetIt.I<SurveyData>().buildingToBeSealed = val;
      } else {
        GetIt.I<SurveyData>().buildingToBeDemolished = val;
      }
      setState(() {});
    };

    return Row(
      children: [
        Radio(
          visualDensity: VisualDensity.compact,
          fillColor: MaterialStateProperty.all(Colors.lightGreen),
          value: true,
          groupValue: groupVal,
          onChanged: onChanged,
        ),
        Text("Yes"),
        SizedBox(width: 10),
        Radio(
          visualDensity: VisualDensity.compact,
          fillColor: MaterialStateProperty.all(Colors.red),
          value: false,
          groupValue: groupVal,
          onChanged: onChanged,
        ),
        Text("No"),
      ],
    );
  }

  Widget buildFurtherActionsEntry() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Actions",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            const Text("Building to be sealed?"),
            radioButtonGroup(true),
            const SizedBox(height: 5),
            const Text("Building to be demolished?"),
            radioButtonGroup(false),
          ],
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
            const SizedBox(height: 20),
            buildSuggestedInterventions(),
            const SizedBox(height: 20),
            buildScanPictures(),
            const SizedBox(height: 20),
            buildFurtherActionsEntry(),
          ],
        ),
      ),
    );
  }
}
