import 'dart:core';

class Post {
  final int id;
  final double lat;
  final double lon;
  final String address;
  final double rating;
  final String review;
  final List<String> pictures;

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
