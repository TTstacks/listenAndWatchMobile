import 'dart:async';
import 'package:flutter/material.dart';
import 'package:listenandwatch/widgets/definition_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:subtitle/subtitle.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class SubtitlePage extends StatefulWidget {
  final FlickManager flickManager;
  final String subtitleUrl;

  const SubtitlePage({
    super.key,
    required this.flickManager,
    required this.subtitleUrl,
  });

  @override
  State<SubtitlePage> createState() => _SubtitlePageState();
}

class _SubtitlePageState extends State<SubtitlePage> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  VideoPlayerController? videoPlayerController;
  List<Subtitle> subtitles = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadSubtitles();
    _startListeningToPosition();
    videoPlayerController = widget.flickManager.flickVideoManager?.videoPlayerController;
  }

  Future<void> _loadSubtitles() async {
    final controller = SubtitleController(
      provider: SubtitleProvider.fromNetwork(Uri.parse(widget.subtitleUrl)),
    );

    await controller.initial();
    setState(() {
      subtitles = controller.subtitles;
    });
  }

  void _startListeningToPosition() {
    


    timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (videoPlayerController!.value.isInitialized) {
        final currentPosition = videoPlayerController!.value.position;
        _scrollToCurrentSubtitle(currentPosition);
      }
    });
  }

  void _scrollToCurrentSubtitle(Duration position) {


    if(!videoPlayerController!.value.isPlaying) return;

    for (int i = 0; i < subtitles.length; i++) {
      final sub = subtitles[i];
      if (position >= sub.start && position <= sub.end) {
        // Scroll near current subtitle
        if (itemScrollController.isAttached) {
          itemScrollController.scrollTo(
            index: (i - 2).clamp(0, subtitles.length - 1),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
        break;
      }
    }
  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: subtitles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: StreamBuilder<Duration>(
                stream: Stream.periodic(const Duration(milliseconds: 300), (_) {
                  final vc = widget
                      .flickManager.flickVideoManager!.videoPlayerController;
                  return vc!.value.isInitialized ? vc.value.position : Duration.zero;
                }),
                builder: (context, snapshot) {
                  final currentPosition = snapshot.data ?? Duration.zero;
          
                  return ScrollablePositionedList.builder(
                    
                    itemCount: subtitles.length,
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
                    itemBuilder: (context, index) {
                      final sub = subtitles[index];
                      final isActive = currentPosition >= sub.start &&
                          currentPosition <= sub.end;
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: SelectableText(
                          sub.data,
                          textAlign: TextAlign.center,
                          contextMenuBuilder: _contextMenuBuilder,
                          style: TextStyle(
                            color: isActive ? Colors.black : Colors.black54,
                            fontSize: isActive ? 24 : 20,
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.normal,
                             backgroundColor: isActive
                            ? Colors.yellow.withOpacity(0.2)
                            : Colors.transparent,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
  

   


Widget _contextMenuBuilder(BuildContext context, EditableTextState editableTextState){

    final selection = editableTextState.textEditingValue.selection;
    final text = editableTextState.textEditingValue.text;
    String selectedWord = text;


    

    if (selection.isValid &&
        selection.start >= 0 &&
        selection.end <= text.length &&
        selection.start != selection.end) {
      selectedWord =
          text.substring(selection.start, selection.end).trim();
    }
    videoPlayerController?.pause();

    
    return SimpleDialog(
      backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    contentPadding: const EdgeInsets.all(0),
      children: [
      SizedBox(width: 250, height: 250, 
        child: SingleChildScrollView( child: DefinitionWidget(word: selectedWord)))
    ]);

    
  }

}
