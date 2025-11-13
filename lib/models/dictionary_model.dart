// dictionary_model.dart
class DictionaryEntry {
  final String word;
  final String? phonetic;
  final List<Phonetic> phonetics;
  final String? origin;
  final List<Meaning> meanings;

  DictionaryEntry({
    required this.word,
    this.phonetic,
    required this.phonetics,
    this.origin,
    required this.meanings,
  });

  factory DictionaryEntry.fromJson(Map<String, dynamic> json) {
    return DictionaryEntry(
      word: json['word'],
      phonetic: json['phonetic'],
      phonetics: (json['phonetics'] as List)
          .map((p) => Phonetic.fromJson(p))
          .toList(),
      origin: json['origin'],
      meanings: (json['meanings'] as List)
          .map((m) => Meaning.fromJson(m))
          .toList(),
    );
  }
}

class Phonetic {
  final String? text;
  final String? audio;

  Phonetic({this.text, this.audio});

  factory Phonetic.fromJson(Map<String, dynamic> json) {
    return Phonetic(
      text: json['text'],
      audio: json['audio'],
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  Meaning({required this.partOfSpeech, required this.definitions});

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'],
      definitions: (json['definitions'] as List)
          .map((d) => Definition.fromJson(d))
          .toList(),
    );
  }
}

class Definition {
  final String definition;
  final String? example;
  final List<String> synonyms;
  final List<String> antonyms;

  Definition({
    required this.definition,
    this.example,
    required this.synonyms,
    required this.antonyms,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'],
      example: json['example'],
      synonyms: List<String>.from(json['synonyms'] ?? []),
      antonyms: List<String>.from(json['antonyms'] ?? []),
    );
  }
}
