# CCTV & Network Academy

Flutter app for CCTV installers and network technicians. Includes:

- **Storage & Bandwidth Calculator** – estimate Mbps and TB needed
- **RJ45 Wiring Guide** – T-568A / T-568B pinouts + PoE power standards
- **Interactive Quizzes** – IP networking, PoE, hardware knowledge
- **Diagnostic Simulator** – real-world troubleshooting scenarios

## Project Structure

```
lib/
├── main.dart
├── helpers/
│   ├── cctv_calculator.dart      # Bitrate / storage math
│   ├── cable_data.dart           # T568A/B wire colors
│   └── database_helper.dart      # SQLite + seed data
├── models/
│   └── quiz_question.dart
└── screens/
    ├── main_navigation.dart      # Bottom nav shell
    ├── dashboard_screen.dart
    ├── calculator_screen.dart
    ├── wiring_screen.dart
    └── quiz_screen.dart
```

## What was wrong with the original code

1. **Everything was pasted into one file** – Dart needs each library in its own file (or properly part-of). Imports like `import 'cctv_calculator.dart';` failed because the file didn’t exist.
2. **Incomplete types** – `Future<List>>` and `List>` were invalid. Fixed to `List<Map<String, dynamic>>`.
3. **Missing `main.dart`** – no entry point.
4. **Missing `pubspec.yaml`** – dependencies `sqflite` and `path` were never declared.
5. **Key constructors** – changed to modern `super.key`.
6. **Null safety & casting** – added proper casts when reading from SQLite maps.
7. **Loading / empty states** – QuizScreen now shows a spinner and handles empty data cleanly.

## How to run

1. Install Flutter (https://docs.flutter.dev/get-started/install)
2. From the project root:

```bash
flutter pub get
flutter run
```

## Adding more content

- Extra quiz questions → edit the seed `INSERT` statements inside `database_helper.dart` (or add a proper migration later).
- New modules → insert into the `modules` table and load by `module_id` in `QuizScreen`.

## Notes

- Storage formula uses decimal TB (1 TB = 10¹² bytes).
- Bitrate estimates are rule-of-thumb only; real cameras vary by scene complexity, GOP, and vendor encoder.
- On first launch the SQLite database is created and seeded automatically.
