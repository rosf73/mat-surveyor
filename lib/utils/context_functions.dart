import 'package:flutter/material.dart';
import 'package:mat_surveyors/add.dart';

void showAddPopup(BuildContext context) {
  showDialog(context: context, builder: (context) {
    return const Dialog(child: AddPopup());
  });
}
