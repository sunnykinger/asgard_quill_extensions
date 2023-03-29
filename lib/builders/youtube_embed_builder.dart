import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../widgets/youtube_player.dart';

class YoutubeEmbedBuilder extends EmbedBuilder {
  YoutubeEmbedBuilder({this.onVideoInit});

  final void Function(GlobalKey videoContainerKey)? onVideoInit;

  @override
  String get key => BlockEmbed.videoType;

  @override
  Widget build(BuildContext context, QuillController controller, Embed node,
      bool readOnly, bool inline) {
    final videoUrl = node.value.data;
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      return YouTubePlayer(
          videoUrl: videoUrl, context: context, readOnly: readOnly);
    }
    return const SizedBox();
  }
}
