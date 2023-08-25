import 'package:flutter/material.dart';
import 'package:rvs/survey_forms/inputs/structcomp_input.dart';

class StructComponentsForm extends StatefulWidget {
  const StructComponentsForm({Key? key}) : super(key: key);

  @override
  StructComponentsFormState createState() => StructComponentsFormState();
}

class StructComponentsFormState extends State<StructComponentsForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const SingleChildScrollView(
      child: StructCompInput(),
    );
  }
}
