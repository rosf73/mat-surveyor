import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'res/colors.dart';
import 'utils/pair.dart';

class AddPopup extends StatefulWidget {
  final Pair<double, double>? location;
  const AddPopup({
    super.key,
    this.location,
  });

  @override
  State<StatefulWidget> createState() => _AddPopupState();
}

class _AddPopupState extends State<AddPopup> {
  late String address;

  final InputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: MatColors.primary,
      width: 2,
    )
  );

  @override
  void initState() {
    super.initState();
    if (widget.location != null) {
      address = '${widget.location!.first}, ${widget.location!.second}'; // 추후에 Geocoder 연동
    } else {
      address = '장소를 골라보세요!';
    }
  }

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
                child: AddPopupInput(address: address),
              ),
            ),
            const AddPopupButtons(),
          ],
        ),
      ),
    );
  }
}

class AddPopupInput extends StatelessWidget {
  final String address;
  const AddPopupInput({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      const SizedBox(height: 28,),
      Text(address),
      const SizedBox(height: 10,),
      Align(
        alignment: AlignmentDirectional.center,
        child: RatingBar.builder(
          initialRating: 1,
          minRating: 1,
          allowHalfRating: true,
          unratedColor: MatColors.primary60,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
          itemSize: 35,
          itemBuilder: (context, _) => const Icon(
            CupertinoIcons.star_fill,
            color: MatColors.primary,
          ),
          onRatingUpdate: (rating) {

          },
        ),
      ),
      const SizedBox(height: 24,),
      TextField(
        decoration: InputDecoration(
          labelText: '평가를 해보자',
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: MatColors.primary, width: 2,)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: MatColors.primary, width: 2,)
          ),
          labelStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: MatColors.primary20,
        ),
        cursorColor: MatColors.primary200,
        minLines: 10,
        maxLines: 10,
        maxLength: 500,
      ),
      const SizedBox(height: 24,),
      const Text('사진 첨부'),
      const SizedBox(height: 28,),
    ],
  );
}

class AddPopupButtons extends StatelessWidget {
  const AddPopupButtons({super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.max,
    // crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: SizedBox(
          height: 60,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
              backgroundColor: Colors.white,
            ),
            child: const Text('닫기'),
          ),
        ),
      ),
      Expanded(
        child: SizedBox(
          height: 60,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
              backgroundColor: MatColors.primary,
            ),
            child: const Text('저장', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ],
  );
}
