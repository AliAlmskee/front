import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

class ImageUtils {
  /// Convert a Base64 string to `Uint8List` (binary data)
  static Uint8List convertBase64ToUint8List(String base64String) {
    return base64Decode(base64String);
  }

  /// Convert a file to a Base64 string for server uploads
  static Future<String> convertFileToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes(); // Read file as bytes
      return base64Encode(bytes); // Convert bytes to Base64 string
    } catch (e) {
      throw Exception("Error converting file to Base64: $e");
    }
  }

  /// Convert `Uint8List` to a Base64 string
  static String convertUint8ListToBase64(Uint8List data) {
    return base64Encode(data);
  }
}
