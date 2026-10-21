import 'dart:math' as math;

import 'package:ai_buddy/audio_generation/sfx_generate.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

enum Sfx {
  burst,
  beamIncorrect,
  redForming,
  beamCorrect,
  split,
  alert,
  click,
  switchOn,
  switchOff,
  tick,
  popupOpen,
  popupClose,
}

class SfxPlayer {
  SfxPlayer._();
  static final SfxPlayer instance = SfxPlayer._();

  final _sources = <Sfx, AudioSource>{};
  final _rnd = math.Random();
  bool _ready = false;
  int _lastTick = 0;
  final _loops = <Sfx, SoundHandle>{};

  bool isLooping(Sfx sfx) => _loops.containsKey(sfx);

  // Call once at startup.
  Future<void> init() async {
    if (_ready) return;
    await SoLoud.instance.init();

    final wavs = {
      Sfx.burst: GameSfx.bubbleBurst(),
      Sfx.beamIncorrect: GameSfx.beamIncorrect(),
      Sfx.redForming: GameSfx.redBubbleForming(),
      Sfx.beamCorrect: GameSfx.beamCorrect(),
      Sfx.split: GameSfx.bubbleSplit(),
      Sfx.alert: GameSfx.alert(),
      Sfx.click: GameSfx.click(),
      Sfx.switchOn: GameSfx.switchOn(),
      Sfx.switchOff: GameSfx.switchOff(),
      Sfx.tick: GameSfx.tick(),
      Sfx.popupOpen: GameSfx.popupOpen(),
      Sfx.popupClose: GameSfx.popupClose(),
    };
  // Plays the scroll tick, at most once per [minGapMs].
  void tick({int minGapMs = 45, double volume = 0.6}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastTick < minGapMs) return;
    _lastTick = now;
    play(Sfx.tick, volume: volume);
  }
    for (final e in wavs.entries) {
      _sources[e.key] = await SoLoud.instance.loadMem(
        '${e.key.name}.wav',
        e.value,
      );
    }
    _ready = true;
  }

  // Plays a sound. [varyPitch] adds a small random speed change so repeated sounds don't feel identical.
  Future<void> play(
    Sfx sfx, {
    double volume = 1.0,
    bool varyPitch = true,
  }) async {
    if (!_ready) return;
    final source = _sources[sfx];
    if (source == null) return;

    final handle = await SoLoud.instance.play(source, volume: volume);
    if (varyPitch) {
      final speed = 0.92 + _rnd.nextDouble() * 0.16;
      SoLoud.instance.setRelativePlaySpeed(handle, speed);
    }
  }

  // Starts a looping sound. Does nothing if it is already looping.
  Future<void> startLoop(Sfx sfx, {double volume = 0.8}) async {
    if (!_ready || _loops.containsKey(sfx)) return;
    final source = _sources[sfx];
    if (source == null) return;

    _loops[sfx] = await SoLoud.instance.play(
      source,
      volume: volume,
      looping: true,
    );
  }

  Future<void> stopLoop(Sfx sfx) async {
    final handle = _loops.remove(sfx);
    if (handle == null) return;
    try {
      await SoLoud.instance.stop(handle);
    } catch (_) {
      // already stopped
    }
  }

  // Click once to start, click again to stop. Returns the new state.
  Future<bool> toggleLoop(Sfx sfx, {double volume = 0.8}) async {
    if (isLooping(sfx)) {
      await stopLoop(sfx);
      return false;
    }
    await startLoop(sfx, volume: volume);
    return true;
  }

  // Plays the scroll tick, at most once per [minGapMs].
  void tick({int minGapMs = 45, double volume = 0.6}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastTick < minGapMs) return;
    _lastTick = now;
    play(Sfx.tick, volume: volume);
  }

  Future<void> dispose() async {
    for (final sfx in _loops.keys.toList()) {
      await stopLoop(sfx);
    }
    for (final s in _sources.values) {
      await SoLoud.instance.disposeSource(s);
    }
    _sources.clear();
    SoLoud.instance.deinit();
    _ready = false;
  }
}
