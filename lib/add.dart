import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mat_surveyors/data/db_helper.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

import 'res/colors.dart';
import 'utils/pair.dart';

class AddPopup extends StatefulWidget {
  final Pair<double, double>? location;
  final Function() onCancel;
  const AddPopup({
    super.key,
    this.location,
    required this.onCancel,
  });

  @override
  State<StatefulWidget> createState() => _AddPopupState();
}

class _AddPopupState extends State<AddPopup> {
  late String address;
  double rating = 0;
  TextEditingController reviewController = TextEditingController(text: '');
  List<XFile> pictures = [];

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
                child: AddPopupInput(
                  address: address,
                  rating: rating,
                  reviewController: reviewController,
                  pictures: pictures,
                  onChangeRating: (value) {
                    rating = value;
                  },
                  onAddPictures: (value) {
                    setState(() {
                      int cutLength = 4 - value.length;
                      if (cutLength == 0) {
                        pictures = value;
                      } else if (pictures.length > cutLength) {
                        pictures = pictures.sublist(pictures.length - cutLength);
                        pictures.addAll(value);
                      } else {
                        pictures.addAll(value);
                      }
                    });
                  },
                  onRemovePicture: (index) {
                    setState(() {
                      pictures.removeAt(index);
                    });
                  },
                ),
              ),
            ),
            AddPopupButtons(
              onCancel: widget.onCancel,
              onSave: () {
                DBHelper().insertToPost(
                  widget.location!.first, widget.location!.second,
                  address, rating, reviewController.text,
                  pictures.map((e) => e.path).toList(),
                );
                widget.onCancel();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddPopupInput extends StatelessWidget {
  final String address;
  final double rating;
  final TextEditingController reviewController;
  final List<XFile> pictures;
  final Function(double) onChangeRating;
  final Function(List<XFile>) onAddPictures;
  final Function(int) onRemovePicture;
  const AddPopupInput({
    super.key,
    required this.address,
    required this.rating,
    required this.reviewController,
    required this.pictures,
    required this.onChangeRating,
    required this.onAddPictures,
    required this.onRemovePicture,
  });

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      const SizedBox(height: 28,),
      Text(address, style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 10,),
      Align(
        alignment: AlignmentDirectional.center,
        child: RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          allowHalfRating: true,
          unratedColor: MatColors.onPrimary60,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 3.5),
          itemSize: 35,
          itemBuilder: (context, _) => const Icon(
            Typicons.star_full_outline,
            color: MatColors.onPrimary,
          ),
          onRatingUpdate: onChangeRating,
        ),
      ),
      const SizedBox(height: 24,),
      TextField(
        decoration: InputDecoration(
          labelText: '평가를 해보자',
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: MatColors.onPrimary, width: 4,)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: MatColors.onPrimary, width: 4,)
          ),
          labelStyle: const TextStyle(color: Colors.black54, fontSize: 20),
          filled: true,
          fillColor: MatColors.primary,
        ),
        controller: reviewController,
        cursorColor: MatColors.onPrimary200,
        minLines: 10,
        maxLines: 10,
        maxLength: 500,
        style: const TextStyle(fontSize: 20),
      ),
      const SizedBox(height: 24,),
      const Text('사진 첨부', style: TextStyle(fontSize: 20)),
      const SizedBox(height: 10,),
      AddPopupPictures(
        pictures: pictures,
        onAddPictures: onAddPictures,
        onRemovePicture: onRemovePicture,
      ),
      const SizedBox(height: 28,),
    ],
  );
}

class AddPopupPictures extends StatefulWidget {
  final List<XFile> pictures;
  final Function(List<XFile>) onAddPictures;
  final Function(int) onRemovePicture;
  const AddPopupPictures({
    super.key,
    required this.pictures,
    required this.onAddPictures,
    required this.onRemovePicture,
  });

  @override
  State<StatefulWidget> createState() => _AddPopupPicturesState();
}

class _AddPopupPicturesState extends State<AddPopupPictures> {
  final ImagePicker _picker = ImagePicker();

  void addPicture() async {
    final List<XFile> images = await _picker.pickMultiImage();
    widget.onAddPictures(images);
  }

  void removePicture(int index) {
    widget.onRemovePicture(index);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      physics: const NeverScrollableScrollPhysics(), // no scrollable option
      children: [
        for (final (index, file) in widget.pictures.indexed)
          GridPicture(
            file: file,
            onDelete: () {
              removePicture(index);
            },
          ),

        if (widget.pictures.length < 4)
          EmptyPicture(onClick: addPicture),
      ],
    );
  }
}

class EmptyPicture extends StatelessWidget {
  final Function() onClick;
  const EmptyPicture({
    super.key,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          color: Colors.black12,
          strokeWidth: 4,
          dashPattern: const [8, 4],
          child: const Center(
            child: Icon(Icons.add_circle, color: Colors.black12,),
          ),
        ),
      ),
    );
  }
}

class GridPicture extends StatelessWidget {
  final XFile file;
  final Function() onDelete;
  const GridPicture({
    super.key,
    required this.file,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Image.file(
          width: double.infinity,
          height: double.infinity,
          File(file.path),
          fit: BoxFit.cover,
        ),
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          style: IconButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(3.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(CupertinoIcons.minus_square_fill, color: MatColors.highlight),
          onPressed: () {
            onDelete();
          },
        ),
      ],
    );
  }
}

class AddPopupButtons extends StatelessWidget {
  final Function() onCancel;
  final Function() onSave;
  const AddPopupButtons({
    super.key,
    required this.onCancel,
    required this.onSave,
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
            onPressed: onSave,
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
              backgroundColor: MatColors.onPrimary,
            ),
            child: const Text('저장', style: TextStyle(color: MatColors.primary, fontSize: 20)),
          ),
        ),
      ),
    ],
  );
}
