import 'package:flutter/material.dart';
import 'package:mat_surveyors/utils/context_functions.dart';
import 'package:mat_surveyors/utils/pair.dart';

class AddExtendButton extends StatelessWidget {
  final Function onClick;
  const AddExtendButton({
    super.key,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 3,
      onPressed: () => onClick(),
      label: const Text('마커 추가하기', style: TextStyle(fontWeight: FontWeight.bold)),
      icon: const Icon(Icons.add),
    );
  }
}

class AddOnCurrentPositionButton extends StatelessWidget {
  final Pair<double, double>? location;
  final Function onClick;
  const AddOnCurrentPositionButton({
    super.key,
    required this.location,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 3,
      onPressed: () {
        onClick();
        showAddPopup(context, location);
      },
      backgroundColor: Colors.white,
      label: const Text(
        '현채 마커에서',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 255, 110, 110),
        ),
      ),
      icon: const Icon(
        Icons.location_on_outlined,
        color: Color.fromARGB(255, 255, 110, 110),
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
      elevation: 3,
      onPressed: () {
        onClick();
        showAddPopup(context, null);
      },
      backgroundColor: Colors.white,
      label: const Text(
        '주소 직접입력',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 255, 110, 110),
        ),
      ),
      icon: const Icon(
        Icons.abc,
        color: Color.fromARGB(255, 255, 110, 110),
      ),
    );
  }
}
