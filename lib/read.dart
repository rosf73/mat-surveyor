import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mat_surveyors/data/local/dto/post.dart';
import 'package:mat_surveyors/res/colors.dart';

class ReadPopup extends StatelessWidget {
  final Post post;
  final Function() onCancel;
  const ReadPopup({
    super.key,
    required this.post,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ReadPopupContainer(post: post),
              ),
            ),
            ReadPopupButtons(
              onCancel: onCancel,
              onModify: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ReadPopupContainer extends StatelessWidget {
  final Post post;
  const ReadPopupContainer({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      const SizedBox(height: 28,),
      Text(post.address, style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 24,),
      const Text('사진 기록', style: TextStyle(fontSize: 20)),
      const SizedBox(height: 10,),
      ReadPopupPictures(urls: post.pictures),
      const SizedBox(height: 24,),
      const Text('글 기록', style: TextStyle(fontSize: 20)),
      const SizedBox(height: 10,),
      ReadPopupReview(review: post.review),
      const SizedBox(height: 28,),
    ],
  );
}

class ReadPopupPictures extends StatelessWidget {
  final List<String> urls;
  const ReadPopupPictures({
    super.key,
    required this.urls,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 150,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (final url in urls)
          Image.file(
            width: 150,
            height: 150,
            File(url),
            fit: BoxFit.cover,
          ),

        if (urls.isEmpty)
          const Text('등록된 사진이 없습니다', style: TextStyle(fontSize: 18)),
      ],
    ),
  );
}

class ReadPopupReview extends StatelessWidget {
  final String review;
  const ReadPopupReview({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Text(review, style: const TextStyle(fontSize: 18));
  }
}

class ReadPopupButtons extends StatelessWidget {
  final Function() onCancel;
  final Function() onModify;
  const ReadPopupButtons({
    super.key,
    required this.onCancel,
    required this.onModify,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.max,
    // crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: SizedBox(
          height: 60,
          child: TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
              backgroundColor: MatColors.primary,
            ),
            child: const Text('닫기', style: TextStyle(color: MatColors.onPrimary, fontSize: 20)),
          ),
        ),
      ),
      Expanded(
        child: SizedBox(
          height: 60,
          child: TextButton(
            onPressed: onModify,
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
              backgroundColor: MatColors.onPrimary,
            ),
            child: const Text('수정', style: TextStyle(color: MatColors.primary, fontSize: 20)),
          ),
        ),
      ),
    ],
  );
}
