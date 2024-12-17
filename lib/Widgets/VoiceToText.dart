import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceSearchWidget extends StatefulWidget {
  final Function(String) onQueryChanged;

  const VoiceSearchWidget({super.key, required this.onQueryChanged});

  @override
  _VoiceSearchWidgetState createState() => _VoiceSearchWidgetState();
}

class _VoiceSearchWidgetState extends State<VoiceSearchWidget> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onState: $val'),
      onError: (val) => print('onError: $val'),
    );
    print("avaiable $available");

    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        String recognizedWords = result.recognizedWords.trim();
        if (recognizedWords.endsWith('.')) {
          recognizedWords =
              recognizedWords.substring(0, recognizedWords.length - 1);
        }
        widget.onQueryChanged(recognizedWords);
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
      onPressed: () {
        if (_isListening) {
          _stopListening();
        } else {
          _startListening();
        }
      },
    );
  }
}
