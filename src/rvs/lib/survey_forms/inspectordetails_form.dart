import 'package:rvs/survey_forms/survey_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class InspectorDetailsForm extends StatefulWidget {
  const InspectorDetailsForm({Key? key}) : super(key: key);

  @override
  State<InspectorDetailsForm> createState() => _InspectorDetailsFormState();
}

class _InspectorDetailsFormState extends State<InspectorDetailsForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController inspIDCtl = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  TextEditingController coordsCtl = TextEditingController();
  bool isLoadingLocation = false;

  @override
  void initState() {
    dateCtl.text = DateTime.now().toIso8601String().substring(0, 10);
    timeCtl.text = DateTime.now().toIso8601String().substring(11, 16);
    GetIt.I<SurveyData>().inspDate = dateCtl.text;
    GetIt.I<SurveyData>().inspTime = timeCtl.text;

    super.initState();
  }

  TextFormField buildInspId(int inspNo) {
    return TextFormField(
      onChanged: (val) {
        if (inspNo == 1) {
          GetIt.I<SurveyData>().inspID1 = val.trim();
        }
        if (inspNo == 2) {
          GetIt.I<SurveyData>().inspID2 = val.trim();
        }
        if (inspNo == 3) {
          GetIt.I<SurveyData>().inspID3 = val.trim();
        }
      },
      // controller: inspIDCtl,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        icon: const Icon(Icons.person),
        labelText: "Inspector ID $inspNo",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AutofillGroup(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: Column(
                children: [
                  buildInspId(1),
                  const SizedBox(height: 20),
                  buildInspId(2),
                  const SizedBox(height: 20),
                  buildInspId(3),
                  const SizedBox(height: 20),
                  // Date Selection
                  TextFormField(
                    onChanged: (val) {},
                    readOnly: true,
                    controller: dateCtl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.date_range),
                      labelText: "Inspection Date",
                    ),
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        dateCtl.text = date.toIso8601String().substring(0, 10);
                        GetIt.I<SurveyData>().inspDate = dateCtl.text;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Time Selection
                  TextFormField(
                    readOnly: true,
                    controller: timeCtl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.lock_clock),
                      labelText: "Inspection Time",
                    ),
                    onTap: () async {
                      TimeOfDay time = TimeOfDay.now();
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: time,
                      );

                      // siddharth: why picked != time
                      if (picked != null) {
                        // can ignore this prblem because localisation shouldn't change across this async gap
                        // ignore: use_build_context_synchronously
                        timeCtl.text = picked.format(context);
                        GetIt.I<SurveyData>().inspTime = timeCtl.text;
                        setState(() {
                          time = picked;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'cant be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
