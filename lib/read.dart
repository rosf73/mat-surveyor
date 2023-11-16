import 'package:flutter/material.dart';
import 'package:mat_surveyors/data/local/dto/post.dart';

class ReadPopup extends StatelessWidget {
  final Post post;
  const ReadPopup({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.white,
        child: const Column(
          children: [

          ],
        ),
      ),
    );
  }
}
