import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Icon icon;
  final void Function()? onPressed;
  const ActionButton({required this.onPressed, required this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: Theme.of(context).colorScheme.inversePrimary.withAlpha(150),
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}
