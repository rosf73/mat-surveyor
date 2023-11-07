import 'package:flutter/material.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

import 'res/colors.dart';
import 'utils/context_functions.dart';
import 'utils/pair.dart';

class AddExtendButton extends StatelessWidget {
  final Function onClick;
  const AddExtendButton({
    super.key,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 0,
      onPressed: () => onClick(),
      label: const Text(
        '마커 추가하기',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: MatColors.onPrimary,
        ),
      ),
      icon: const Icon(Typicons.pencil, color: MatColors.onPrimary),
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 5, color: MatColors.onPrimary),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class AddOnCurrentPositionButton extends StatelessWidget {
  final bool enable;
  final Pair<double, double>? location;
  final Function onClick;
  const AddOnCurrentPositionButton({
    super.key,
    required this.enable,
    required this.location,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 0,
      onPressed: () {
        if (enable) {
          onClick();
          showAddPopup(context, location);
        }
      },
      backgroundColor: MatColors.onPrimary,
      label: const Text(
        '현채 마커에서',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: MatColors.primary,
        ),
      ),
      icon: const Icon(
        Typicons.location_outline,
        color: MatColors.primary,
      ),
    );
  }
}

class AddOnNewPositionButton extends StatelessWidget {
  final Function onClick;
  const AddOnNewPositionButton({
    super.key,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 0,
      onPressed: () {
        onClick();
        showAddPopup(context, null);
      },
      backgroundColor: MatColors.onPrimary,
      label: const Text(
        '주소 직접입력',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: MatColors.primary,
        ),
      ),
      icon: const Icon(
        Typicons.zoom_outline,
        color: MatColors.primary,
      ),
    );
  }
}
