import 'package:flutter/material.dart';
import 'package:mat_surveyors/add.dart';
import 'package:mat_surveyors/utils/pair.dart';

void showAddPopup(BuildContext context, Pair<double, double>? location) {
  showDialog(
    context: context,
    barrierColor: const Color.fromARGB(120, 150, 75, 75),
    builder: (context) {
      return Dialog(child: AddPopup(location: location,));
    },
  );
}
