import 'dart:typed_data';

import '../local/dto/post.dart';
import '../local/dto/location.dart';

class MapData {
  static final MapData _instance = MapData._();

  static List<Post> _posts = [];
  List<Post> get posts => _posts;
  set posts(List<Post> newList) => _posts = newList;

  List<Location> get locations => _posts.map(
    (e) => Location(e.id, e.lat, e.lon, e.address)
  ).toList();

  MapData._();

  factory MapData() => _instance;

  insertPost(int id, double lat, double lon, String address, double rating, String review, List<Uint8List> pictures) {
    _posts.add(Post(id, lat, lon, address, rating, review, pictures));
  }

  updatePost(int id, double rating, String address, String review, List<Uint8List> pictures) {
    final index = _posts.indexWhere((e) => e.id == id);
    _posts[index] = Post(id, _posts[index].lat, _posts[index].lon, address, rating, review, pictures);
  }

  deletePost(int id) {
    _posts.removeWhere((e) => e.id == id);
  }

  clearPost() {
    _posts.clear();
  }
}
