import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  /// Initialize speech recognition
  Future<bool> initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print("Speech status: $status"),
      onError: (error) => print("Speech error: $error"),
    );
    return available;
  }

  /// Listen to user's voice and return recognized text
  Future<String> listen() async {
    String recognizedText = '';

    // Make sure speech is initialized
    if (!_speech.isAvailable) {
      bool initialized = await initSpeech();
      if (!initialized) return recognizedText;
    }

    await _speech.listen(
      onResult: (result) {
        recognizedText = result.recognizedWords;
      },
      localeId: 'en_US',              
      listenMode: ListenMode.dictation,
    );

    // Wait until user stops speaking
    await Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 100));
      return _speech.isListening;
    });

    await _speech.stop();
    return recognizedText;
  }

  /// Convert text to speech
  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(text);
  }
}