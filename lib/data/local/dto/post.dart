import 'dart:core';
import 'dart:typed_data';

class Post {
  final int id;
  final double lat;
  final double lon;
  final String address;
  final double rating;
  final String review;
  final List<Uint8List> pictures;

  Post(
    this.id,
    this.lat,
    this.lon,
    this.address,
    this.rating,
    this.review,
    this.pictures,
  );
}
