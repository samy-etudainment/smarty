# ai_buddy_sfx

Synthesized sound effects for Flutter. No audio assets: sounds are generated in Dart and played with `flutter_soloud`.```

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
await SoundEffects.init(only: {Sfx.click, Sfx.beamCorrect});
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

## Sounds

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

## Notes

- Use a hot restart after changing a sound, since they are built at startup.
- A looping alert keeps playing across screens. Stop it with `SoundEffects.stopLoop(Sfx.alert)`.
- Call `SoundEffects.dispose()` only when the app closes, never from a page.
