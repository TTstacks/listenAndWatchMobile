
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listenandwatch/screens/subtitle_page.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String subtitleUrl;
  final String title;
  const VideoPlayerPage({super.key, required this.videoUrl, required this.subtitleUrl, required this.title});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }
    flickManager = FlickManager(videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl)
      ));
  }

  

  @override
  void dispose() {
    flickManager.dispose();
    if (kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;

    return Scaffold(
        appBar: AppBar(
          title: Text(title)
        ),
        body: Column(
          children: [
            FlickVideoPlayer(flickManager: flickManager),
            Expanded(
            child: SubtitlePage(
              flickManager: flickManager,
              subtitleUrl: widget.subtitleUrl,
            ),
          ),
          ]
        )
    );
    


  }
}