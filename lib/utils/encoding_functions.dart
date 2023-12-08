import 'dart:convert';
import 'dart:typed_data';

const Base64Codec base64 = Base64Codec();

String encodeToBase64(Uint8List data) {
  return base64.encode(data);
}

Uint8List decodeFromBase64(String base64String) {
  return base64.decode(base64String);
}

List<String> encodeToBase64List(List<Uint8List> data) {
  return data.map((e) => encodeToBase64(e)).toList();
}
