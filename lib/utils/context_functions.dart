import 'package:flutter/material.dart';

import '../add.dart';
import '../res/colors.dart';
import '../utils/pair.dart';

void showAddPopup(BuildContext context, Pair<double, double>? location) {
  showDialog(
    context: context,
    barrierColor: MatColors.modalBackground,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        child: AddPopup(
          location: location,
          onCancel: () {
            Navigator.pop(context);
          },
        )
      );
    },
  );
}
