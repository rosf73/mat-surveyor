import 'dart:typed_data';

import 'package:flutter/material.dart';

class PicturePreview extends StatelessWidget {
  final Uint8List imageData;
  const PicturePreview({
    super.key,
    required this.imageData,
  });

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      width: double.infinity,
      height: double.infinity,
      imageData,
      fit: BoxFit.cover,
    );
  }
}
