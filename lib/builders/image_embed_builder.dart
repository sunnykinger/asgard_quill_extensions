import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart' as base;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:tuple/tuple.dart';

import '../utils.dart';

class ImageEmbedBuilder implements EmbedBuilder {
  final void Function(bool isReadOnly)? onImageTapped;

  ImageEmbedBuilder({this.onImageTapped});

  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    base.Embed node,
    bool readOnly,
  ) {
    assert(!kIsWeb, 'Please provide image EmbedBuilder for Web');
    final imageUrl = Utils.standardizeImageUrl(node.value.data);
    Widget image = Utils.imageByUrl(imageUrl);
    Tuple2<double?, double?>? widthHeight;
    final style = node.style.attributes['style'];
    if (base.isMobile() && style != null) {
      final attrs = base.parseKeyValuePairs(style.value.toString(), {
        Attribute.mobileWidth,
        Attribute.mobileHeight,
        Attribute.mobileMargin,
        Attribute.mobileAlignment
      });
      if (attrs.isNotEmpty) {
        assert(
            attrs[Attribute.mobileWidth] != null &&
                attrs[Attribute.mobileHeight] != null,
            'mobileWidth and mobileHeight must be specified');
        final w = double.parse(attrs[Attribute.mobileWidth]!);
        final h = double.parse(attrs[Attribute.mobileHeight]!);
        widthHeight = Tuple2(w, h);
        final m = attrs[Attribute.mobileMargin] == null
            ? 0.0
            : double.parse(attrs[Attribute.mobileMargin]!);
        final a = base.getAlignment(attrs[Attribute.mobileAlignment]);
        image = Padding(
            padding: EdgeInsets.all(m),
            child:
                Utils.imageByUrl(imageUrl, width: w, height: h, alignment: a));
      }
    }

    if (widthHeight == null) {
      image = Utils.imageByUrl(imageUrl);
      widthHeight = Tuple2((image as Image).width, image.height);
    }

    if (!readOnly && base.isMobile()) {
      return GestureDetector(
          onTap: () {
            onImageTapped?.call(false);
          },
          child: image);
    }

    if (!readOnly || !base.isMobile() || Utils.isImageBase64(imageUrl)) {
      return image;
    }

    // We provide option menu for mobile platform excluding base64 image
    return _menuOptionsForReadonlyImage(context, imageUrl, image);
  }

  Widget _menuOptionsForReadonlyImage(
      BuildContext context, String imageUrl, Widget image) {
    return GestureDetector(
        onTap: () {
          onImageTapped?.call(true);
        },
        child: image);
  }
}
