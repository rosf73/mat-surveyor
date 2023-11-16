import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mat_surveyors/read.dart';

import '../add.dart';
import '../data/local/dto/post.dart';
import '../res/colors.dart';
import '../utils/pair.dart';

void showAddPopup(BuildContext context, Pair<double, double>? location) {
  showDialog(
    context: context,
    barrierColor: MatColors.modalBackground,
    barrierDismissible: false,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Dialog(
          insetPadding: const EdgeInsets.all(15),
          child: AddPopup(
            location: location,
            onCancel: () {
              Navigator.pop(context);
            },
          )
        ),
      );
    },
  );
}

void showReadPopup(BuildContext context, Post post) {
  showDialog(
    context: context,
    barrierColor: MatColors.modalBackground,
    barrierDismissible: false,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Dialog(
            insetPadding: const EdgeInsets.all(15),
            child: ReadPopup(
              post: post,
              onCancel: () {
                Navigator.pop(context);
              },
            )
        ),
      );
    },
  );
}
