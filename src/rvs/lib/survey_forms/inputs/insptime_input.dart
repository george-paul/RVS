import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../survey_data.dart';

class InspTimeInput extends StatefulWidget {
  const InspTimeInput({super.key});

  @override
  State<InspTimeInput> createState() => _InspTimeInputState();
}

class _InspTimeInputState extends State<InspTimeInput> {
  @override
  void initState() {
    timeCtl.text = DateTime.now().toIso8601String().substring(11, 16);
    GetIt.I<SurveyData>().inspTime = timeCtl.text;
    super.initState();
  }

  //
  // ------------------------ Time Selection ------------------------
  //

  TextEditingController timeCtl = TextEditingController();

  Widget buildTimeSelect() {
    return TextFormField(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTimeSelect();
  }
}
