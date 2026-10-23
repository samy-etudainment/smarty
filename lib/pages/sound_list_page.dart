import 'package:ai_buddy/audio_generation/sound_effect.dart';
import 'package:flutter/material.dart';

class SoundListPage extends StatefulWidget {
  const SoundListPage({super.key});

  @override
  State<SoundListPage> createState() => _SoundListPageState();
}

class _SoundListPageState extends State<SoundListPage> {
  // (sound, label, icon, loop)
  static const _items = <(Sfx, String, IconData, bool)>[
    (Sfx.burst, 'Burst', Icons.bubble_chart, false),
    (Sfx.redForming, 'Red bubble forming', Icons.circle, false),
    (Sfx.beamIncorrect, 'Wrong Beam', Icons.close, false),
    (Sfx.beamCorrect, 'Correct Beam', Icons.check, false),
    (Sfx.laser, 'Laser sound', Icons.call_split, false),
    (Sfx.split, 'Bubble Split', Icons.call_split, false),
    (Sfx.alert, 'Alert', Icons.notifications_active, true),
    (Sfx.click, 'Click', Icons.touch_app, false),
    (Sfx.switchOn, 'Switch On', Icons.toggle_on, false),
    (Sfx.switchOff, 'Switch Off', Icons.toggle_off, false),
    (Sfx.tick, 'Scroll Tick', Icons.unfold_more, false),
    (Sfx.popupOpen, 'Pop-up Open', Icons.open_in_new, false),
    (Sfx.popupClose, 'Pop-up Close', Icons.close_fullscreen, false),
  ];

  static const _game = <(Sfx, String, IconData, bool)>[
    (Sfx.splash, 'Game Start', Icons.rocket_launch, false),
    (Sfx.gameMusic, 'Game music', Icons.music_note, true),
  ];

  /*static const _emotions = <(Sfx, String, IconData, bool)>[
    (Sfx.veryHappy, 'Very Happy', Icons.sentiment_very_satisfied, false),
    (Sfx.veryDisappointed, 'Very Disappointed', Icons.sentiment_very_dissatisfied, false),
    (Sfx.angry, 'Angry / Frustrated', Icons.whatshot, false),
    (Sfx.verySurprised, 'Very Surprised', Icons.flash_on, false),
    (Sfx.excited, 'Excited / Energetic', Icons.bolt, false),
    (Sfx.satisfied, 'Satisfied / Relaxed', Icons.spa, false),
    (Sfx.stressed, 'Stressed / Rushed', Icons.timer, true),
    (Sfx.proud, 'Proud / Triumphant', Icons.emoji_events, false),
  ];*/

  @override
  void dispose() {
    // Sounds are global, so stop looping sounds when leaving.
    SoundEffects.stopLoop(Sfx.alert);
    SoundEffects.stopLoop(Sfx.stressed);
    SoundEffects.stopLoop(Sfx.gameMusic);
    super.dispose();
  }

  Future<void> _onTap(Sfx sfx, bool loop) async {
    if (loop) {
      await SoundEffects.toggleLoop(sfx);
      if (mounted) setState(() {});
    } else {
      SoundEffects.play(sfx);
    }
  }

  Widget _section(String title, List<(Sfx, String, IconData, bool)> items) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (sfx, label, icon, loop) in items)
              _SfxButton(
                label: label,
                icon: icon,
                active: loop && SoundEffects.isLooping(sfx),
                onPressed: () => _onTap(sfx, loop),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3664A1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('Sound list'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                _section('GAME & UI', _items),
                _section('GAME AUDIO', _game),
                //_section('EMOTIONS', _emotions),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SfxButton extends StatelessWidget {
  const _SfxButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.active = false,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: active
          ? ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            )
          : null,
      icon: Icon(active ? Icons.stop : icon, size: 18),
      label: Text(active ? 'Stop $label' : label),
    );
  }
}