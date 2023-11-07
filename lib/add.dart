import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
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
            AddPopupButtons(
              onCancel: widget.onCancel,
            ),
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
          unratedColor: MatColors.onPrimary60,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 3.5),
          itemSize: 35,
          itemBuilder: (context, _) => const Icon(
            Typicons.star_full_outline,
            color: MatColors.onPrimary,
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
            borderSide: const BorderSide(color: MatColors.onPrimary, width: 4,)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: MatColors.onPrimary, width: 4,)
          ),
          labelStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: MatColors.primary,
        ),
        cursorColor: MatColors.onPrimary200,
        minLines: 10,
        maxLines: 10,
        maxLength: 500,
      ),
      const SizedBox(height: 24,),
      const Text('사진 첨부'),
      const SizedBox(height: 10,),
      const AddPopupPictures(),
      const SizedBox(height: 28,),
    ],
  );
}

class AddPopupPictures extends StatefulWidget {
  const AddPopupPictures({super.key});

  @override
  State<StatefulWidget> createState() => _AddPopupPicturesState();
}

class _AddPopupPicturesState extends State<AddPopupPictures> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _pictures = [];

  void addPicture() async {
    // TODO : check size limit
    final List<XFile> images = await _picker.pickMultiImage();

    setState(() {
      _pictures.addAll(images);
    });
  }

  void removePicture(int index) {
    setState(() {
      _pictures.removeAt(index);
    });
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
        for (final (index, file) in _pictures.indexed)
          GridPicture(
            file: file,
            onDelete: () {
              removePicture(index);
            },
          ),

        if (_pictures.length < 4)
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
  const AddPopupButtons({
    super.key,
    required this.onCancel,
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
            child: const Text('닫기', style: TextStyle(color: MatColors.onPrimary)),
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
              backgroundColor: MatColors.onPrimary,
            ),
            child: const Text('저장', style: TextStyle(color: MatColors.primary)),
          ),
        ),
      ),
    ],
  );
}
