import 'package:ai_buddy/audio/sfx_audio.dart';
import 'package:flutter/material.dart';

import 'speech_page.dart';

class SoundListPage extends StatefulWidget {
  const SoundListPage({super.key});

  @override
  State<SoundListPage> createState() => _SoundListPageState();
}

class _SoundListPageState extends State<SoundListPage> {
  // (sound, label, icon, loop)
  // loop = true: tap to start, tap again to stop.
  static const _items = <(Sfx, String, IconData, bool)>[
    (Sfx.burst, 'Burst', Icons.bubble_chart, false),
    (Sfx.redForming, 'Red bubble forming', Icons.circle, false),
    (Sfx.beamIncorrect, 'Wrong Beam', Icons.close, false),
    (Sfx.beamCorrect, 'Correct Beam', Icons.check, false),
    (Sfx.split, 'Bubble Split', Icons.call_split, false),
    (Sfx.alert, 'Alert', Icons.notifications_active, true),
    (Sfx.click, 'Click', Icons.touch_app, false),
    (Sfx.switchOn, 'Switch On', Icons.toggle_on, false),
    (Sfx.switchOff, 'Switch Off', Icons.toggle_off, false),
    (Sfx.tick, 'Scroll Tick', Icons.unfold_more, false),
    (Sfx.popupOpen, 'Pop-up Open', Icons.open_in_new, false),
    (Sfx.popupClose, 'Pop-up Close', Icons.close_fullscreen, false),
  ];

  // Sounds that must always play at the same pitch: musical cues and
  // sounds whose direction (up/down) carries meaning.
  static const _fixedPitch = {
    Sfx.beamCorrect,
    Sfx.beamIncorrect,
    Sfx.switchOn,
    Sfx.switchOff,
    Sfx.popupOpen,
    Sfx.popupClose,
  };

  @override
  void dispose() {
    // The player is a singleton, so stop the looping alert when leaving.
    SfxPlayer.instance.stopLoop(Sfx.alert);
    super.dispose();
  }

  Future<void> _onTap(Sfx sfx, bool loop) async {
    if (loop) {
      await SfxPlayer.instance.toggleLoop(sfx);
      if (mounted) setState(() {});
    } else {
      SfxPlayer.instance.play(sfx, varyPitch: !_fixedPitch.contains(sfx));
    }
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
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (sfx, label, icon, loop) in _items)
                  _SfxButton(
                    label: label,
                    icon: icon,
                    active: loop && SfxPlayer.instance.isLooping(sfx),
                    onPressed: () => _onTap(sfx, loop),
                  ),
                FilledButton.icon(
                  onPressed: () {
                    SfxPlayer.instance.play(Sfx.click);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SpeechPage()),
                    );
                  },
                  icon: const Icon(Icons.record_voice_over, size: 18),
                  label: const Text('Text to speech'),
                ),
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