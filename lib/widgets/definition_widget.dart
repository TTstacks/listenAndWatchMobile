


import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:listenandwatch/models/dictionary_model.dart';
import 'package:listenandwatch/widgets/translation_widget.dart';

class DefinitionWidget extends StatefulWidget{

  final String word;

  const DefinitionWidget({super.key, required this.word});  

  @override
  State<DefinitionWidget> createState() => _DefinitionWidgetState();
}


class _DefinitionWidgetState extends State<DefinitionWidget>{

  late Future<DictionaryEntry> definition;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    definition = _fetchDefinition();
  }


  Future<DictionaryEntry> _fetchDefinition() async{
    final response = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/${widget.word}'));
    
    final data = jsonDecode(response.body);

    return DictionaryEntry.fromJson(data[0]);
  }

  void _playAudio(String url) async {
    if (url.isEmpty) return;
    await _audioPlayer.play(UrlSource(url.startsWith('http') ? url : 'https:$url'));
  }


  @override
  void dispose() {
    
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<DictionaryEntry>(
      future: definition,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 250,
            width: 250,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          );
        }
        
        if (!snapshot.hasData) {

          return Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslationWidget(text: widget.word),
                const Padding(
            padding: EdgeInsets.all(12),
            child: Text('No definition found.',
                style: TextStyle(color: Colors.black87)),
          )
              ],
            )
          )
          );

        }

        final entry = snapshot.data!;
        final phonetic = entry.phonetic ?? entry.phonetics.firstOrNull?.text;
        final audioUrl = entry.phonetics.firstWhere(
              (p) => p.audio?.isNotEmpty ?? false,
              orElse: () => Phonetic(),
            ).audio ??
            '';


       

        return Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslationWidget(text: widget.word),
                /// Word + Speaker
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.word,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (audioUrl.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: Colors.blueGrey),
                        onPressed: () => _playAudio(audioUrl),
                      ),
                  ],
                ),
            
                if (phonetic != null)
                  Text(
                    phonetic,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
            
                const SizedBox(height: 8),
            
                /// Meanings
                ...entry.meanings.map((meaning) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meaning.partOfSpeech,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...meaning.definitions.take(2).map((d) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  d.definition,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                                if (d.example != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '“${d.example}”',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )),
                      const Divider(height: 12),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

}