// sound_effect.dart
import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'sfx_generate.dart';

enum Sfx {
  burst,
  beamIncorrect(varyPitch: false),
  redForming(varyPitch: false),
  laser(varyPitch: false),
  beamCorrect(varyPitch: false),
  split,
  alert(volume: 0.8, varyPitch: false),
  click,
  switchOn(varyPitch: false),
  switchOff(varyPitch: false),
  tick(volume: 0.6),
  popupOpen(varyPitch: false),
  popupClose(varyPitch: false);

  const Sfx({this.volume = 1.0, this.varyPitch = true});
  final double volume;
  final bool varyPitch;
}

class SoundEffects {
  SoundEffects._();

  static const _poolSize = 6;

  static final _bytes = <Sfx, Uint8List>{};
  static final _loops = <Sfx, AudioPlayer>{};
  static final _pool = <AudioPlayer>[];
  static final _rnd = math.Random();
  static Future<void>? _initFuture;
  static bool _ready = false;
  static int _lastTick = 0;
  static int _next = 0;

  static bool enabled = true;

  static final Map<Sfx, Uint8List Function()> _builders = {
    Sfx.burst: GameSfx.bubbleBurst,
    Sfx.beamIncorrect: GameSfx.beamIncorrect,
    Sfx.redForming: GameSfx.redBubbleForming,
    Sfx.laser: GameSfx.laser,
    Sfx.beamCorrect: GameSfx.beamCorrect,
    Sfx.split: GameSfx.bubbleSplit,
    Sfx.alert: GameSfx.alert,
    Sfx.click: GameSfx.click,
    Sfx.switchOn: GameSfx.switchOn,
    Sfx.switchOff: GameSfx.switchOff,
    Sfx.tick: GameSfx.tick,
    Sfx.popupOpen: GameSfx.popupOpen,
    Sfx.popupClose: GameSfx.popupClose,
  };

  static Future<void> init({Set<Sfx>? only}) =>
      _initFuture ??= _init(only ?? Sfx.values.toSet()).catchError((Object e) {
        _initFuture = null;
        throw e;
      });

  static Future<void> _init(Set<Sfx> wanted) async {
    for (final sfx in wanted) {
      _bytes[sfx] = _builders[sfx]!();
    }
    for (var i = 0; i < _poolSize; i++) {
      final p = AudioPlayer();
      await p.setPlayerMode(PlayerMode.mediaPlayer);
      await p.setReleaseMode(ReleaseMode.stop);
      _pool.add(p);
    }
    _ready = true;
  }

  static Future<void> play(Sfx sfx, {double? volume, bool? varyPitch}) async {
    if (!enabled || !_ready) return;
    final bytes = _bytes[sfx];
    if (bytes == null) return;

    try {
      final p = _pool[_next];
      _next = (_next + 1) % _pool.length;
      await p.stop();
      await p.setVolume(volume ?? sfx.volume);
      if (varyPitch ?? sfx.varyPitch) {
        await p.setPlaybackRate(0.92 + _rnd.nextDouble() * 0.16);
      } else {
        await p.setPlaybackRate(1.0);
      }
      await p.play(BytesSource(bytes));
    } catch (e) {
      debugPrint('SFX play failed ($sfx): $e');
    }
  }

  static void tick({int minGapMs = 45}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastTick < minGapMs) return;
    _lastTick = now;
    play(Sfx.tick);
  }

  // Loops
  static bool isLooping(Sfx sfx) => _loops.containsKey(sfx);

  static Future<void> startLoop(Sfx sfx, {double? volume}) async {
    if (!enabled || !_ready || _loops.containsKey(sfx)) return;
    final bytes = _bytes[sfx];
    if (bytes == null) return;
    try {
      final p = AudioPlayer();
      _loops[sfx] = p;
      await p.setReleaseMode(ReleaseMode.loop);
      await p.setVolume(volume ?? sfx.volume);
      await p.play(BytesSource(bytes));
    } catch (_) {
      _loops.remove(sfx);
    }
  }

  static Future<void> stopLoop(Sfx sfx) async {
    final p = _loops.remove(sfx);
    if (p == null) return;
    try {
      await p.stop();
      await p.dispose();
    } catch (_) {}
  }

  static Future<bool> toggleLoop(Sfx sfx, {double? volume}) async {
    if (isLooping(sfx)) {
      await stopLoop(sfx);
      return false;
    }
    await startLoop(sfx, volume: volume);
    return isLooping(sfx);
  }

  static Future<void> stopAllLoops() async {
    for (final sfx in _loops.keys.toList()) {
      await stopLoop(sfx);
    }
  }

  static Future<void> dispose() async {
    await stopAllLoops();
    for (final p in _pool) {
      await p.dispose();
    }
    _pool.clear();
    _bytes.clear();
    _ready = false;
    _initFuture = null;
  }
}
