
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:string_validator/string_validator.dart';

class Utils{
  static bool isImageBase64(String imageUrl) {
    return !imageUrl.startsWith('http') && isBase64(imageUrl);
  }

  static String standardizeImageUrl(String url) {
    if (url.contains('base64')) {
      return url.split(',')[1];
    }
    return url;
  }

  static Image imageByUrl(String imageUrl,
      {double? width,
        double? height,
        AlignmentGeometry alignment = Alignment.center}) {
    if (isImageBase64(imageUrl)) {
      return Image.memory(base64.decode(imageUrl),
          width: width, height: height, alignment: alignment);
    }

    if (imageUrl.startsWith('http')) {
      return Image.network(imageUrl,
          width: width, height: height, alignment: alignment);
    }
    return Image.file(File(imageUrl),
        width: width, height: height, alignment: alignment);
  }

  static String getImageStyleString(QuillController controller) {
    final String? s = controller
        .getAllSelectionStyles()
        .firstWhere((s) => s.attributes.containsKey(Attribute.style.key),
        orElse: () => Style())
        .attributes[Attribute.style.key]
        ?.value;
    return s ?? '';
  }
}