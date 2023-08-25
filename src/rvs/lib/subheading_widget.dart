import 'package:flutter/material.dart';

class SubHeading extends StatelessWidget {
  final String label;
  final TextStyle? style;

  const SubHeading({
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
          Text(
            label,
            style: usedStyle,
          ),
        ],
      ),
    );
  }
}
