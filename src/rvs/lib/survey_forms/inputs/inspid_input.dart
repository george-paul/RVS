import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../survey_data.dart';

class InspIDInput extends StatefulWidget {
  final int inspNo;
  const InspIDInput({super.key, required this.inspNo});

  @override
  State<InspIDInput> createState() => _InspIDInputState();
}

class _InspIDInputState extends State<InspIDInput> {
  //
  // ------------------------ Insp ID ------------------------
  //

  Widget buildInspID() {
    return TextFormField(
      onChanged: (val) {
        if (widget.inspNo == 1) {
          GetIt.I<SurveyData>().inspID1 = val.trim();
        }
        if (widget.inspNo == 2) {
          GetIt.I<SurveyData>().inspID2 = val.trim();
        }
        if (widget.inspNo == 3) {
          GetIt.I<SurveyData>().inspID3 = val.trim();
        }
      },
      // controller: inspIDCtl,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        icon: const Icon(Icons.person),
        labelText: "Inspector ID ${widget.inspNo}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildInspID();
  }
}
