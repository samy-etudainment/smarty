# ai_buddy_sfx

Synthesized sound effects and music for Flutter. No audio assets: sounds are generated in Dart and played with `flutter_soloud`.

## Setup

Call `init()` once before `runApp`.

```dart
import 'package:ai_buddy_sfx/ai_buddy_sfx.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SoundEffects.init();
  runApp(const MyApp());
}
```

To load only some sounds:

```dart
await SoundEffects.init(only: {Sfx.click, Sfx.beamCorrect, Sfx.splash});
```

## Use

```dart
onPressed: () {
  SoundEffects.play(Sfx.click);
}
```

```dart
SoundEffects.play(Sfx.beamIncorrect, volume: 1.2);  // custom volume
SoundEffects.toggleLoop(Sfx.alert);                 // start/stop the alert
SoundEffects.tick();                                // scroll or slider tick
SoundEffects.enabled = false;                       // mute everything
```

### Splash screen and game music

```dart
SoundEffects.play(Sfx.splash);          // when the splash screen appears
SoundEffects.startLoop(Sfx.gameMusic);  // when the game starts
SoundEffects.stopLoop(Sfx.gameMusic);   // on pause / game over
```

## Sounds

### Game and UI

| Sfx | Use |
|---|---|
| `burst` | Bubble burst |
| `beamCorrect` | Correct answer |
| `beamIncorrect` | Wrong answer |
| `redForming` | Red bubble forming |
| `laser` | Short descending laser zap |
| `split` | Bubble splits |
| `alert` | Soft looping alert |
| `click` | Any button |
| `switchOn` / `switchOff` | Switches |
| `tick` | Scrolling, sliders |
| `popupOpen` / `popupClose` | Pop-ups |

### Game audio

| Sfx | Use |
|---|---|
| `splash` | Splash screen sting (about 2.8 s): boing, sparkly arpeggio, soft final chord that fades out |
| `gameMusic` | Cartoonish background music. Looping, 8 bars at 132 BPM, quieter by default (volume 0.35) |

### Emotions

| Sfx | Use |
|---|---|
| `veryHappy` | Very happy |
| `veryDisappointed` | Very disappointed |
| `angry` | Angry / frustrated |
| `verySurprised` | Very surprised |
| `excited` | Excited / energetic |
| `satisfied` | Satisfied / relaxed |
| `stressed` | Stressed / rushed (looping) |
| `proud` | Proud / triumphant |

## Loops

Looping sounds are `alert`, `stressed` and `gameMusic`.

```dart
SoundEffects.startLoop(Sfx.gameMusic);
SoundEffects.stopLoop(Sfx.gameMusic);
SoundEffects.toggleLoop(Sfx.alert);  
SoundEffects.isLooping(Sfx.alert);
SoundEffects.stopAllLoops();
```

## Notes

- Use a hot restart after changing a sound, since they are built at startup.
- Loops keep playing across screens. Stop them with `SoundEffects.stopLoop(...)` when leaving a page, or use `stopAllLoops()`.
- Call `SoundEffects.dispose()` only when the app closes, never from a page.
- `gameMusic` is about 14.5 s of audio generated at startup. If you notice a startup hitch, load only what the first screen needs with `init(only: {...})`, or build the music in an isolate.
- The splash sting and the music live in `game_audio_generate.dart`. To change their feel (tempo, notes, volume), edit that file.