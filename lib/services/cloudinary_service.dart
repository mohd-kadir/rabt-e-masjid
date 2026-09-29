import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'y6xewhcn';
  static const String uploadPreset = 'rabt_masjid_images';

  static Future<String> uploadImage({
    required File imageFile,
    required String folder,
  }) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', url);

    request.fields['upload_preset'] = uploadPreset;
    request.fields['folder'] = folder;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ),
    );

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception(
        'Cloudinary upload failed: ${response.statusCode}\n$responseBody',
      );
    }

    final responseData = jsonDecode(responseBody);

    final secureUrl = responseData['secure_url']?.toString();

    if (secureUrl == null || secureUrl.isEmpty) {
      throw Exception('Cloudinary did not return an image URL.');
    }

    return secureUrl;
  }
}