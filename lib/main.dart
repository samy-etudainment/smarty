import 'package:ai_buddy/ai_buddy/edutainer.dart';
import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: DemoPage()),
);

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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AiBudddyEdutainment(
              size: 120,
              emotion: EdutainerEmotion.normal,
            ),
            const AiBudddyEdutainment(
              size: 120,
              bodyColor: Colors.amber,
              saucerColor: Colors.deepOrangeAccent,
              emotion: EdutainerEmotion.sad,
              //pose: EdutainerPose(mouthOpen: 0, tongueOut: 0, mischief: 0),
            ),
            const AiBudddyEdutainment(
              size: 150,
              bodyColor: Colors.purple,
              saucerColor: Colors.teal,
              emotion: EdutainerEmotion.love
            ),
            const AiBudddyEdutainment(
              size: 150,
              bodyColor: Colors.teal,
              saucerColor: Colors.blueAccent,
              speed: 1.5,
              showShadow: true,
              emotion: EdutainerEmotion.normal,
              targets: _targets,
            ),
          ],
        ),
      ),
    );
  }
}
