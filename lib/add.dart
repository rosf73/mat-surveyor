import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPopup extends StatefulWidget {
  const AddPopup({super.key});

  @override
  State<StatefulWidget> createState() => _AddPopupState();
}

class _AddPopupState extends State<AddPopup> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("제목"),
        Text("내용내용"),
      ],
    );
  }
}
