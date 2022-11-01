import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuple/tuple.dart';

import 'builders/image_embed_builder.dart';
import 'builders/youtube_embed_builder.dart';

class QuillEmbeds {
  static List<EmbedBuilder> builders(
          {void Function(GlobalKey videoContainerKey)? onVideoInit,
          void Function(bool isReadOnly, Tuple2<double?, double?>? widthHeight)?
              onImageTapped}) =>
      [
        ImageEmbedBuilder(onImageTapped: onImageTapped),
        YoutubeEmbedBuilder(onVideoInit: onVideoInit),
      ];

  static List<EmbedButtonBuilder> buttons(
    BuildContext context, {
    void Function()? onImageTapped,
    void Function()? onYouTubeInsertTapped,
    void Function()? onAttachmentInsertTapped,
  }) {
    final theme = Theme.of(context);
    return [
      (controller, toolbarIconSize, iconTheme, dialogTheme) => QuillIconButton(
            icon: Icon(Icons.image,
                size: kDefaultIconSize,
                color: iconTheme?.iconUnselectedColor ?? theme.iconTheme.color),
            highlightElevation: 0,
            hoverElevation: 0,
            size: toolbarIconSize * 1.77,
            fillColor:
                iconTheme?.iconUnselectedFillColor ?? (theme.canvasColor),
            borderRadius: iconTheme?.borderRadius ?? 2,
            onPressed: () {
              onImageTapped?.call();
            },
          ),
      (controller, toolbarIconSize, iconTheme, dialogTheme) => QuillIconButton(
            icon: Icon(FontAwesomeIcons.youtube,
                size: kDefaultIconSize,
                color: iconTheme?.iconUnselectedColor ?? theme.iconTheme.color),
            highlightElevation: 0,
            hoverElevation: 0,
            size: toolbarIconSize * 1.77,
            fillColor:
                iconTheme?.iconUnselectedFillColor ?? (theme.canvasColor),
            borderRadius: iconTheme?.borderRadius ?? 2,
            onPressed: () {
              onYouTubeInsertTapped?.call();
            },
          ),
      (controller, toolbarIconSize, iconTheme, dialogTheme) => QuillIconButton(
            icon: Icon(FontAwesomeIcons.paperclip,
                size: kDefaultIconSize,
                color: iconTheme?.iconUnselectedColor ?? theme.iconTheme.color),
            highlightElevation: 0,
            hoverElevation: 0,
            size: toolbarIconSize * 1.77,
            fillColor:
                iconTheme?.iconUnselectedFillColor ?? (theme.canvasColor),
            borderRadius: iconTheme?.borderRadius ?? 2,
            onPressed: () {
              onAttachmentInsertTapped?.call();
            },
          )
    ];
  }
}
