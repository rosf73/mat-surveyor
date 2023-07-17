import 'package:flutter/material.dart';

class AddExtendButton extends StatelessWidget {
  const AddExtendButton({super.key});

  void onPressed() {

  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: const Color.fromARGB(255, 255, 110, 110),
      label: const Text('마커 추가', style: TextStyle(fontWeight: FontWeight.bold)),
      icon: const Icon(Icons.add),
    );
  }
}

class AddOnCurrentPositionButton extends StatelessWidget {
  const AddOnCurrentPositionButton({super.key});

  void onPressed() {

  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: Colors.white,
      label: const Text(
        '현재 위치에서',
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
  const AddOnNewPositionButton({super.key});

  void onPressed() {

  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: Colors.white,
      label: const Text(
        '새로운 주소',
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
