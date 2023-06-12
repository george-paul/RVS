import 'package:flutter/material.dart';

class LinedHeading extends StatelessWidget {
  final Text label;

  const LinedHeading({
    super.key,
    required this.label,
  });

  static const double height = 2;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: Theme.of(context).colorScheme.onBackground,
              height: height,
            )),
      ),
      label,
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: Theme.of(context).colorScheme.onBackground,
              height: height,
            )),
      ),
    ]);
  }
}
