import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddPopup extends StatefulWidget {
  const AddPopup({super.key});

  @override
  State<StatefulWidget> createState() => _AddPopupState();
}

class _AddPopupState extends State<AddPopup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          const Text('주소주소주소'),
          const SizedBox(height: 10,),
          Align(
            alignment: AlignmentDirectional.center,
            child: RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              allowHalfRating: true,
              unratedColor: const Color.fromARGB(60, 255, 110, 110),
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              itemSize: 35,
              itemBuilder: (context, _) => const Icon(
                CupertinoIcons.star_fill,
                color: Color.fromARGB(255, 255, 110, 110),
              ),
              onRatingUpdate: (rating) {

              },
            ),
          ),
          const SizedBox(height: 24,),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '한 줄 평',
            ),
          ),
        ],
      ),
    );
  }
}
