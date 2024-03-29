import 'package:flutter/material.dart';

class LinedHeading extends StatelessWidget {
  final String label;
  final TextStyle? style;

  const LinedHeading({
    super.key,
    required this.label,
    this.style,
  });

  static const double height = 2;

  @override
  Widget build(BuildContext context) {
    TextStyle usedStyle;
    if (style == null) {
      usedStyle = Theme.of(context).textTheme.headline5!.copyWith(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          );
    } else {
      usedStyle = style!;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                child: Divider(
                  color: Theme.of(context).colorScheme.onBackground,
                  height: height,
                )),
          ),
          Text(
            label,
            style: usedStyle,
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                child: Divider(
                  color: Theme.of(context).colorScheme.onBackground,
                  height: height,
                )),
          ),
        ],
      ),
    );
  }
}
