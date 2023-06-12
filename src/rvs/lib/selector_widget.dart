import 'package:flutter/material.dart';

import 'util.dart';

class SelectorWidget extends StatefulWidget {
  final String title;
  final List<bool> selectedCheckboxes;
  final List<Pair<bool, String>> options;
  final TextEditingController otherCtl;
  final Function(String) updateCallback;
  const SelectorWidget({
    required this.title,
    required this.selectedCheckboxes,
    required this.options,
    required this.otherCtl,
    required this.updateCallback,
    Key? key,
  }) : super(key: key);

  @override
  SelectorWidgetState createState() => SelectorWidgetState();
}

class SelectorWidgetState extends State<SelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTileCard(
      borderRadius: cardBorderRadius.bottomLeft.x, // equates to the .all.circular's value
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.all(20),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          checkboxString(widget.selectedCheckboxes, widget.options, others: widget.otherCtl.text),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        children: List<Widget>.generate(widget.options.length, (index) {
              return CheckboxListTile(
                title: Text(widget.options[index].b),
                value: widget.selectedCheckboxes[index],
                onChanged: (val) {
                  setState(() {
                    widget.selectedCheckboxes[index] = val!;
                  });
                  if (val = true) {
                    widget.updateCallback(
                      checkboxString(widget.selectedCheckboxes, widget.options, others: widget.otherCtl.text),
                    );
                  }
                },
              );
            }) +
            [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  onChanged: (val) {
                    setState(() {}); // rebuilds tile subtitle
                    widget.updateCallback(
                      checkboxString(widget.selectedCheckboxes, widget.options, others: widget.otherCtl.text),
                    );
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Others (please specify)",
                  ),
                  controller: widget.otherCtl,
                ),
              ),
            ],
      ),
    );
  }
}
