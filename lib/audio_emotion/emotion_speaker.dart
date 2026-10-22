/*import 'package:flutter_tts/flutter_tts.dart';

enum Intonation {
  normal('Normal', 0.45, 1.0),
  jovial('Jovial', 0.50, 1.25),
  joyful('Joyful', 0.58, 1.45),
  sad('Sad', 0.34, 0.75),
  angry('Angry', 0.55, 0.65);

  const Intonation(this.label, this.rate, this.pitch);
  final String label;
  final double rate; // 0.0 - 1.0
  final double pitch; // 0.5 - 2.0
}

class EmotionSpeaker {
  EmotionSpeaker._();
  static final EmotionSpeaker instance = EmotionSpeaker._();

  final _tts = FlutterTts();
  bool _ready = false;

  Future<void> init({String language = 'en-US'}) async {
    if (_ready) return;
    await _tts.setLanguage(language);
    await _tts.setVolume(1.0);
    _ready = true;
  }

  /// Adjusts the text a little so the voice phrases it with the mood.
  String _shape(String text, Intonation tone) {
    final t = text.trim();
    switch (tone) {
      case Intonation.joyful:
      case Intonation.jovial:
        return t.endsWith('!') ? t : '$t!';
      case Intonation.sad:
        return t.replaceAll(', ', '... ').replaceAll(RegExp(r'[!.]+$'), '...');
      case Intonation.angry:
        return t.replaceAll('.', '!');
      case Intonation.normal:
        return t;
    }
  }

  Future<void> speak(String text, Intonation tone) async {
    if (!_ready || text.trim().isEmpty) return;
    await _tts.stop();
    await _tts.setSpeechRate(tone.rate);
    await _tts.setPitch(tone.pitch);
    await _tts.speak(_shape(text, tone));
  }

  Future<void> stop() => _tts.stop();
}*/