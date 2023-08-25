import 'package:flutter/material.dart';
import 'package:rvs/survey_forms/inputs/occupancy_input.dart';

class OccupancyForm extends StatefulWidget {
  const OccupancyForm({Key? key}) : super(key: key);

  @override
  OccupancyFormState createState() => OccupancyFormState();
}

class OccupancyFormState extends State<OccupancyForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const SingleChildScrollView(
      child: OccupancyInput(),
    );
  }
}
