
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:tuple/tuple.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_quill/extensions.dart' as base;
import 'package:flutter_quill/flutter_quill.dart' hide Text;


import '../utils.dart';


class ImageEmbedBuilder implements EmbedBuilder {
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

    var image;
    final imageUrl = Utils.standardizeImageUrl(node.value.data);
    Tuple2<double?, double?>? _widthHeight;
    final style = node.style.attributes['style'];
    if (base.isMobile() && style != null) {
      final _attrs = base.parseKeyValuePairs(style.value.toString(), {
        Attribute.mobileWidth,
        Attribute.mobileHeight,
        Attribute.mobileMargin,
        Attribute.mobileAlignment
      });
      if (_attrs.isNotEmpty) {
        assert(
        _attrs[Attribute.mobileWidth] != null &&
            _attrs[Attribute.mobileHeight] != null,
        'mobileWidth and mobileHeight must be specified');
        final w = double.parse(_attrs[Attribute.mobileWidth]!);
        final h = double.parse(_attrs[Attribute.mobileHeight]!);
        _widthHeight = Tuple2(w, h);
        final m = _attrs[Attribute.mobileMargin] == null
            ? 0.0
            : double.parse(_attrs[Attribute.mobileMargin]!);
        final a = base.getAlignment(_attrs[Attribute.mobileAlignment]);
        image = Padding(
            padding: EdgeInsets.all(m),
            child: Utils.imageByUrl(imageUrl, width: w, height: h, alignment: a));
      }
    }

    if (_widthHeight == null) {
      image = Utils.imageByUrl(imageUrl);
      _widthHeight = Tuple2((image as Image).width, image.height);
    }

    if (!readOnly && base.isMobile()) {
      return GestureDetector(
          onTap: () {
            // showDialog(
            //     context: context,
            //     builder: (context) {
            //       final resizeOption = _SimpleDialogItem(
            //         icon: Icons.settings_outlined,
            //         color: Colors.lightBlueAccent,
            //         text: 'Resize'.i18n,
            //         onPressed: () {
            //           Navigator.pop(context);
            //           showCupertinoModalPopup<void>(
            //               context: context,
            //               builder: (context) {
            //                 final _screenSize = MediaQuery.of(context).size;
            //                 return ImageResizer(
            //                     onImageResize: (w, h) {
            //                       final res = getEmbedNode(
            //                           controller, controller.selection.start);
            //                       final attr = base.replaceStyleString(
            //                           getImageStyleString(controller), w, h);
            //                       controller
            //                         ..skipRequestKeyboard = true
            //                         ..formatText(
            //                             res.item1, 1, StyleAttribute(attr));
            //                     },
            //                     imageWidth: _widthHeight?.item1,
            //                     imageHeight: _widthHeight?.item2,
            //                     maxWidth: _screenSize.width,
            //                     maxHeight: _screenSize.height);
            //               });
            //         },
            //       );
            //       final copyOption = _SimpleDialogItem(
            //         icon: Icons.copy_all_outlined,
            //         color: Colors.cyanAccent,
            //         text: 'Copy'.i18n,
            //         onPressed: () {
            //           final imageNode =
            //               getEmbedNode(controller, controller.selection.start)
            //                   .item2;
            //           final imageUrl = imageNode.value.data;
            //           controller.copiedImageUrl =
            //               Tuple2(imageUrl, getImageStyleString(controller));
            //           Navigator.pop(context);
            //         },
            //       );
            //       final removeOption = _SimpleDialogItem(
            //         icon: Icons.delete_forever_outlined,
            //         color: Colors.red.shade200,
            //         text: 'Remove'.i18n,
            //         onPressed: () {
            //           final offset =
            //               getEmbedNode(controller, controller.selection.start)
            //                   .item1;
            //           controller.replaceText(offset, 1, '',
            //               TextSelection.collapsed(offset: offset));
            //           Navigator.pop(context);
            //         },
            //       );
            //       return Padding(
            //         padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
            //         child: SimpleDialog(
            //             shape: const RoundedRectangleBorder(
            //                 borderRadius:
            //                 BorderRadius.all(Radius.circular(10))),
            //             children: [resizeOption, copyOption, removeOption]),
            //       );
            //     });
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
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       final saveOption = _SimpleDialogItem(
          //         icon: Icons.save,
          //         color: Colors.greenAccent,
          //         text: 'Save'.i18n,
          //         onPressed: () {
          //           imageUrl = appendFileExtensionToImageUrl(imageUrl);
          //           GallerySaver.saveImage(imageUrl).then((_) {
          //             ScaffoldMessenger.of(context)
          //                 .showSnackBar(SnackBar(content: Text('Saved'.i18n)));
          //             Navigator.pop(context);
          //           });
          //         },
          //       );
          //       final zoomOption = _SimpleDialogItem(
          //         icon: Icons.zoom_in,
          //         color: Colors.cyanAccent,
          //         text: 'Zoom'.i18n,
          //         onPressed: () {
          //           Navigator.pushReplacement(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) =>
          //                       ImageTapWrapper(imageUrl: imageUrl)));
          //         },
          //       );
          //       return Padding(
          //         padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          //         child: SimpleDialog(
          //             shape: const RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.all(Radius.circular(10))),
          //             children: [saveOption, zoomOption]),
          //       );
          //     });
        },
        child: image);
  }

}