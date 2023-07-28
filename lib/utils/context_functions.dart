import 'package:flutter/material.dart';
import 'package:mat_surveyors/add.dart';

void showAddPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: const Color.fromARGB(120, 150, 75, 75),
    builder: (context) {
      return const Dialog(child: AddPopup());
    },
  );
}
