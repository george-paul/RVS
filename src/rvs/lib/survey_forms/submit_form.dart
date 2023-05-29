// ignore_for_file: prefer_const_constructors

import 'package:rvs/survey_forms/survey_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../util.dart';

class SubmitForm extends StatefulWidget {
  const SubmitForm({Key? key}) : super(key: key);

  @override
  State<SubmitForm> createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  bool isLoading = false;

  void generatePDF() async {
    GetIt.I<SurveyData>().calcPESA();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Spacer(),
            Text(
              "Generate your report with this button: ",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                generatePDF();
              },
              child: Visibility(
                visible: isLoading,
                replacement: Text("Generate"),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                  child: SizedBox(
                    height: Theme.of(context).textTheme.labelLarge?.fontSize,
                    width: Theme.of(context).textTheme.labelLarge?.fontSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: (!isDarkTheme(context)) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
