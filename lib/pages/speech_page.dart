import 'package:ai_buddy/audio/emotion_speaker.dart';
import 'package:flutter/material.dart';

class SpeechPage extends StatefulWidget {
  const SpeechPage({super.key});

  @override
  State<SpeechPage> createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  final _controller =
      TextEditingController(text: 'Great job, that is the correct answer');
  Intonation _tone = Intonation.normal;

  @override
  void dispose() {
    EmotionSpeaker.instance.stop(); // stop talking when leaving the page
    _controller.dispose();
    super.dispose();
  }

  void _speak() {
    FocusScope.of(context).unfocus();
    EmotionSpeaker.instance.speak(_controller.text, _tone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3664A1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('Text to speech'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                minLines: 3,
                maxLines: 6,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Type something to say...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Intonation',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tone in Intonation.values)
                    ChoiceChip(
                      label: Text(tone.label),
                      selected: _tone == tone,
                      onSelected: (_) {
                        setState(() => _tone = tone);
                        _speak(); 
                      },
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _speak,
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Speak'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: EmotionSpeaker.instance.stop,
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}