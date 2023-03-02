import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rvs/survey01_forms/survey01_data.dart';

class FurtherActionsForm extends StatefulWidget {
  const FurtherActionsForm({Key? key}) : super(key: key);

  @override
  FurtherActionsFormState createState() => FurtherActionsFormState();
}

class FurtherActionsFormState extends State<FurtherActionsForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  static const BorderRadius borderRadiusCached = BorderRadius.all(Radius.circular(20.0));

  //
  // ----------------------------- Further Actions -----------------------------
  //

  bool buildingToBeQuarantined = false;
  bool detailedScreening = false;

  Widget buildFurtherActionsEntry() {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: borderRadiusCached),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Further Actions",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 15),
            CheckboxListTile(
              title: const Text("Building is to be quarantined?"),
              value: buildingToBeQuarantined,
              onChanged: (val) {
                if (val == null) return;
                setState(() {
                  buildingToBeQuarantined = val;
                });
                GetIt.I<Survey01Data>().buildingToBeQuarantined = val;
              },
            ),
            const SizedBox(height: 15),
            CheckboxListTile(
              title: const Text("Level 2 Detailed Screening is required?"),
              value: detailedScreening,
              onChanged: (val) {
                if (val == null) return;
                setState(() {
                  detailedScreening = val;
                });
                GetIt.I<Survey01Data>().detailedScreening = val;
              },
            )
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
            const SizedBox(height: 30),
            buildFurtherActionsEntry(),
          ],
        ),
      ),
    );
  }
}
