import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../survey_data.dart';

class InspDateInput extends StatefulWidget {
  const InspDateInput({super.key});

  @override
  State<InspDateInput> createState() => _InspDateInputState();
}

class _InspDateInputState extends State<InspDateInput> {
  TextEditingController dateCtl = TextEditingController();

  @override
  void initState() {
    dateCtl.text = DateTime.now().toIso8601String().substring(0, 10);
    GetIt.I<SurveyData>().inspDate = dateCtl.text;
    super.initState();
  }

  //
  // ------------------------ Date Selection ------------------------
  //
  Widget buildDateSelect() {
    return TextFormField(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildDateSelect();
  }
}
