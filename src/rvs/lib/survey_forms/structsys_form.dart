import 'package:rvs/survey_forms/inputs/structstys_input.dart';
import 'package:flutter/material.dart';

class StructSysForm extends StatefulWidget {
  const StructSysForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StructSysFormState createState() => _StructSysFormState();
}

class _StructSysFormState extends State<StructSysForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  //
  // ----------------------------- build -----------------------------
  //
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const SingleChildScrollView(
      child: StructSysInput(),
    );
  }
}
