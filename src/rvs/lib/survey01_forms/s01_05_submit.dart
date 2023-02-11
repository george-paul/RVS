// ignore_for_file: prefer_const_constructors

import 'package:rvs/survey01_forms/survey01_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../util.dart';

class S01SubmitForm extends StatefulWidget {
  const S01SubmitForm({Key? key}) : super(key: key);

  @override
  State<S01SubmitForm> createState() => _S01SubmitFormState();
}

class _S01SubmitFormState extends State<S01SubmitForm> {
  bool calcDone = false;
  bool isLoading = false;

  @override
  void initState() {
    calcDone = GetIt.I<Survey01Data>().calcDone;
    super.initState();
  }

  void generatePDF() async {
    GetIt.I<Survey01Data>().calcRVS();
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
              (calcDone)
                  ? "Generate your report with this button: "
                  : "Report generation is disabled until rating calculation is done in the previous page.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: (calcDone)
                  ? () {
                      generatePDF();
                    }
                  : null,
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
