import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String cloudName = 'dqx11fuzl';
  static const String apiKey = '385474548855814';
  static const String apiSecret = 'NR0PFB_vJCDNKpdOVoIwEvOUnu0';
  static const String uploadPreset = 'flutter_uploads';

  static Future<String?> uploadImage(dynamic imageFile) async {
    try {
      Uint8List imageBytes;
      String fileName;

      if (kIsWeb) {
        // For web, handle XFile
        if (imageFile is XFile) {
          imageBytes = await imageFile.readAsBytes();
          fileName =
              'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        } else {
          throw Exception('Invalid image type for web');
        }
      } else {
        // For mobile, handle File
        if (imageFile is File) {
          imageBytes = await imageFile.readAsBytes();
          fileName = imageFile.path.split('/').last;
        } else {
          throw Exception('Invalid image type for mobile');
        }
      }

      final response = await http.post(
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'file': 'data:image/jpeg;base64,${base64Encode(imageBytes)}',
          'upload_preset': uploadPreset,
          'folder': 'profile_images',
          'public_id': fileName,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['secure_url'];
      } else {
        print('Cloudinary upload failed: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Check if it's a preset error
        if (response.body.contains('Upload preset not found')) {
          print('❌ UPLOAD PRESET ERROR: \n');
          print('You need to create an upload preset in Cloudinary dashboard:');
          print('1. Go to https://cloudinary.com/console/settings/upload');
          print('2. Click "Add upload preset"');
          print('3. Name: flutter_uploads');
          print('4. Signing mode: Unsigned');
          print('5. Save and try again');
        }

        return null;
      }
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  static String getPublicIdFromUrl(String? url) {
    if (url == null || url.isEmpty) return '';

    final regex = RegExp(r'/([^/]+)\.[^.]+$');
    final match = regex.firstMatch(url);

    return match?.group(1) ?? '';
  }

  static String getThumbnailUrl(String? url,
      {int width = 100, int height = 100}) {
    if (url == null || url.isEmpty) return '';

    final publicId = getPublicIdFromUrl(url);
    return 'https://res.cloudinary.com/$cloudName/image/c_fill,w_$width,h_$height,q_auto,f_auto/$publicId.jpg';
  }
}
