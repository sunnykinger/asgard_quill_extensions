
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';



class YouTubePlayer extends StatefulWidget {
  final String videoUrl;
  final BuildContext context;
  final bool readOnly;

  const YouTubePlayer(
      {required this.videoUrl,
        required this.context,
        required this.readOnly,
        Key? key})
      : super(key: key);

  @override
  State<YouTubePlayer> createState() => _YouTubePlayerState();
}

class _YouTubePlayerState extends State<YouTubePlayer> {
  YoutubePlayerController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final videoId = convertYouTubeUrlToId(widget.videoUrl);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        params: const YoutubePlayerParams(
          showControls: true,
          // useHybridComposition: true,
          color: 'Red',
          enableJavaScript: true,
          showFullscreenButton: true,
        ),
      );

      _controller!.stream.listen((event) {
        if (event.playerState == PlayerState.unknown) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyles = DefaultStyles.getInstance(context);
    if (_controller == null) {
      if (widget.readOnly) {
        return RichText(
          text: TextSpan(
              text: widget.videoUrl,
              style: defaultStyles.link,
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchUrl(Uri.parse(widget.videoUrl))),
        );
      }
      return RichText(
          text: TextSpan(text: widget.videoUrl, style: defaultStyles.link));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          YoutubePlayerControllerProvider(
            // Provides controller to all the widget below it.
            controller: _controller!,
            child: const YoutubePlayerIFrame(
              aspectRatio: 16 / 9,
            ),
          ),
          _isLoading
              ? const AspectRatio(
            aspectRatio: 16 / 9,
            child: Center(
                child: IgnorePointer(
                  ignoring: true,
                  child: CircularProgressIndicator(),
                )),
          )
              : const SizedBox(),
        ],
      ),
    );
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  /// Converts fully qualified YouTube Url to video id.
  ///
  /// If videoId is passed as url then no conversion is done.
  String? convertYouTubeUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();
    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }
}