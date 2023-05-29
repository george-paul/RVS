library util;

import 'package:flutter/material.dart';

void greenDBG(String err) {
  debugPrint("\x1B[32m $err \x1B[0m");
}

void redDBG(String err) {
  debugPrint("\x1B[31m $err \x1B[0m");
}

void yellowDBG(String err) {
  debugPrint("\x1B[33m $err \x1B[0m");
}

Color changeBrightness(Color c, double factor) {
  Color newC = c;
  newC = newC.withRed((newC.red * factor).toInt());
  newC = newC.withGreen((newC.green * factor).toInt());
  newC = newC.withBlue((newC.blue * factor).toInt());
  return newC;
}

bool isDarkTheme(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return true;
  } else {
    return false;
  }
}

class Pair<T1, T2> {
  T1 a;
  T2 b;

  Pair(this.a, this.b);

  static List<TA> getUnzippedListOfA<TA, TB>(List<Pair<TA, TB>> list) {
    List<TA> result = [];
    for (int i = 0; i < list.length; i++) {
      result.add(list[i].a);
    }
    return result;
  }

  static List<TB> getUnzippedListOfB<TA, TB>(List<Pair<TA, TB>> list) {
    List<TB> result = [];
    for (int i = 0; i < list.length; i++) {
      result.add(list[i].b);
    }
    return result;
  }
}

String checkboxString(List<bool> checkboxes, List<Pair<bool, String>> optionList, {String? others}) {
  List<String> names = Pair.getUnzippedListOfB(optionList);
  List<String> result = [];
  for (int i = 0; i < checkboxes.length; i++) {
    if (checkboxes[i] == true) {
      result.add(names[i]);
    }
  }
  if (others != null && others.isNotEmpty) {
    result.add(others);
  }

  return prettyListString(result);
}

String prettyListString<T>(List<T> list) {
  String returnString = list.toString().substring(1, list.toString().length - 1);
  if (returnString.trim() == "") {
    return "None";
  }
  return returnString;
}

// custom Widget to round corners of an expansion tile
class ExpansionTileCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  const ExpansionTileCard({Key? key, required this.child, required this.borderRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius br = BorderRadius.all(Radius.circular(borderRadius));

    return ClipRRect(
      borderRadius: br,
      child: Material(
        elevation: 1,
        child: child,
      ),
    );
  }
}

String getStringFromList(List<dynamic> list) {
  if (list.isEmpty) {
    return "None";
  }

  String result = "";
  for (int i = 0; i < list.length; i++) {
    result += "${list[i]}, ";
  }

  result = result.substring(0, result.length - 2);
  return result;
}

const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(20.0));
