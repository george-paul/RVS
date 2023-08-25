import 'package:flutter/material.dart';

class InspectorDetailsForm extends StatefulWidget {
  const InspectorDetailsForm({Key? key}) : super(key: key);

  @override
  State<InspectorDetailsForm> createState() => _InspectorDetailsFormState();
}

class _InspectorDetailsFormState extends State<InspectorDetailsForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
                children: const [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
