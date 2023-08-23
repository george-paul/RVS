import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExplanationScreen extends StatefulWidget {
  final String mdkey;
  const ExplanationScreen({required this.mdkey, super.key});

  @override
  State<ExplanationScreen> createState() => _ExplanationScreenState();
}

class _ExplanationScreenState extends State<ExplanationScreen> {
  String mdData = "";
  bool isLoading = true;

  void getData() async {
    // default MD
    String mdString = "# Could not find this definiton";
    try {
      // mdString = await rootBundle.loadString('assets/explain/${widget.mdkey}.MD');
      mdString = await rootBundle.loadString('assets/explain/default.MD');
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "Could not find this definition");
    }

    setState(() {
      mdData = mdString;
      isLoading = true;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explanation - ${widget.mdkey}"),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Markdown(data: mdData),
      ),
    );
  }
}
