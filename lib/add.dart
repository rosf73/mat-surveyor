import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mat_surveyors/utils/pair.dart';

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
      color: Color.fromARGB(255, 255, 110, 110),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: ListView(
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
          TextField(
            decoration: InputDecoration(
              labelText: '평가를 해보자',
              border: const OutlineInputBorder(),
              enabledBorder: inputBorder,
              focusedBorder: inputBorder,
              labelStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: const Color.fromARGB(20, 255, 110, 110),
            ),
            cursorColor: const Color.fromARGB(200, 255, 110, 110),
            minLines: 10,
            maxLines: 10,
            maxLength: 500,
          ),
          const SizedBox(height: 28,),
        ],
      ),
    );
  }
}
