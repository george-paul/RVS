import 'package:rvs/linedheading_widget.dart';
import 'package:rvs/subheading_widget.dart';
import 'package:rvs/survey_forms/inputs/address_input.dart';
import 'package:rvs/survey_forms/inputs/location_input.dart';
import 'package:rvs/survey_forms/inputs/occupancy_input.dart';
import 'package:rvs/survey_forms/inputs/structcomp_input.dart';
import 'package:rvs/survey_forms/inputs/structstys_input.dart';
import 'package:rvs/survey_forms/inputs/structureview_input.dart';
import 'package:flutter/material.dart';
import 'package:rvs/survey_forms/inputs/vulnerability_input.dart';

import 'inputs/inspdate_input.dart';
import 'inputs/inspid_input.dart';
import 'inputs/insptime_input.dart';

class BuildingDescriptionForm extends StatefulWidget {
  const BuildingDescriptionForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BuildingDescriptionFormState createState() => _BuildingDescriptionFormState();
}

class _BuildingDescriptionFormState extends State<BuildingDescriptionForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
          children: const [
            LinedHeading(label: "Inspector Details"),
            InspIDInput(inspNo: 1),
            SizedBox(height: 20),
            InspIDInput(inspNo: 2),
            SizedBox(height: 20),
            InspIDInput(inspNo: 3),
            SizedBox(height: 20),
            InspDateInput(),
            SizedBox(height: 20),
            InspTimeInput(),
            SizedBox(height: 20),
            LocationInput(),
            SizedBox(height: 20),
            AddressInput(),
            SizedBox(height: 20),
            StructureViewInput(),
            SizedBox(height: 20),
            LinedHeading(label: "Building Details"),
            SubHeading(label: "Structural System"),
            StructSysInput(),
            SizedBox(height: 20),
            SubHeading(label: "Structural Components"),
            StructCompInput(),
            SizedBox(height: 20),
            SubHeading(label: "Structural Components"),
            OccupancyInput(),
            SizedBox(height: 20),
            LinedHeading(label: "Vulnerability Details"),
            VulnerabilityInput(),
          ],
        ),
      ),
    );
  }
}
