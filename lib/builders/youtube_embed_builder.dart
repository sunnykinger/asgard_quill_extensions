
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/extensions.dart' as base;

import '../widgets/youtube_player.dart';

class YoutubeEmbedBuilder implements EmbedBuilder {
  YoutubeEmbedBuilder({this.onVideoInit});

  final void Function(GlobalKey videoContainerKey)? onVideoInit;

  @override
  String get key => BlockEmbed.videoType;

  @override
  Widget build(
      BuildContext context,
      QuillController controller,
      base.Embed node,
      bool readOnly,
      ) {
    final videoUrl = node.value.data;
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      return YouTubePlayer(
          videoUrl: videoUrl, context: context, readOnly: readOnly);
    }
    return const SizedBox();
  }
}