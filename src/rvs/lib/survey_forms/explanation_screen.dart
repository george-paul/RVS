import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
    String mdString = await rootBundle.loadString('assets/explain/default.md');

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
