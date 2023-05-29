import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
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
                FloatingActionButton(
                  onPressed: () {
                    takeSuggScanPicture();
                  },
                  child: const Icon(Icons.camera_enhance_rounded),
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

  bool buildingToBeQuarantined = false;
  bool detailedScreening = false;

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
            CheckboxListTile(
              title: const Text("Building to be sealed?"),
              value: buildingToBeQuarantined,
              onChanged: (val) {
                if (val == null) return;
                setState(() {
                  buildingToBeQuarantined = val;
                });
                GetIt.I<SurveyData>().buildingToBeQuarantined = val;
              },
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
              title: const Text("Building to be demolished?"),
              value: detailedScreening,
              onChanged: (val) {
                if (val == null) return;
                setState(() {
                  detailedScreening = val;
                });
                GetIt.I<SurveyData>().detailedScreening = val;
              },
            )
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
