import 'package:ai_buddy/ai_buddy/edutainer.dart';
import 'package:ai_buddy/audio_emotion/emotion_speaker.dart';
import 'package:ai_buddy/audio_generation/sound_effect.dart';
import 'package:flutter/material.dart';

import 'pages/sound_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SoundEffects.init(); 
  await EmotionSpeaker.instance.init();
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: DemoPage()),
  );
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  static const _targets = [
    EdutainerTarget(Offset(10, 40), 'E=mc²'),
    EdutainerTarget(Offset(410, 60), 'π'),
    EdutainerTarget(Offset(330, -30), '£'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3664A1),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    AiBudddyEdutainment(
                      size: 100,
                      emotion: EdutainerEmotion.normal,
                    ),
                    AiBudddyEdutainment(
                      size: 90,
                      bodyColor: Colors.amber,
                      saucerColor: Colors.deepOrangeAccent,
                      emotion: EdutainerEmotion.sad,
                    ),
                    AiBudddyEdutainment(
                      size: 90,
                      bodyColor: Colors.purple,
                      saucerColor: Colors.teal,
                      emotion: EdutainerEmotion.love,
                    ),
                    AiBudddyEdutainment(
                      size: 100,
                      bodyColor: Colors.teal,
                      saucerColor: Colors.blueAccent,
                      speed: 1.5,
                      showShadow: true,
                      emotion: EdutainerEmotion.angry,
                      targets: _targets,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const _BottomBar(),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        color: Colors.black26,
        child: FilledButton.icon(
          onPressed: () {
            SoundEffects.play(Sfx.laser); 
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SoundListPage()),
            );
          },
          icon: const Icon(Icons.library_music, size: 18),
          label: const Text('Sound list'),
        ),
      ),
    );
  }
}