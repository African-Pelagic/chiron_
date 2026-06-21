<p align="center">
  <img src="./chiron-dark.svg" alt="Chiron" width="180" />
</p>

# Chiron

Chiron is a local-first workout logging app for lifters who want to capture sets quickly without breaking flow.

The core job of the product is simple:

1. Start a session.
2. Log weighted sets by voice or typed fallback.
3. Normalize each set onto a known exercise in your catalog.
4. Review the workout, history, exports, and simple performance trends later.

## Product Overview

Chiron is designed for short, structured gym input rather than free-form coaching chat. It is optimized for phrases like:

- `12 weighted dips 30 kilos`
- `8 pullups 20 kg`
- `5 bench press 100 kg`

Each captured set is stored independently. Repeated sets are grouped for summaries, but the raw session history stays per-set so the data remains useful for export and later analysis.

## What It Does Today

- Start, end, and discard workout sessions
- Capture sets through typed entry
- Capture sets through push-to-talk local transcription
- Require reps, load, and unit before saving
- Resolve exercise phrases to a canonical exercise or alias from your local catalog
- Store an editable exercise library with categories, default units, and aliases
- Import exercises from CSV
- Export all captured sets as CSV with one row per set
- Review previous sessions and per-session detail
- Show a weekly performance chart by exercise category

## Current Product Rules

- A set is only saved if the exercise phrase resolves to a known canonical exercise or alias
- Weighted capture is enforced in the current flow
- Discarding an active session permanently removes that in-progress session and its captured sets
- All data is local on the device unless you export it yourself

## Who It Is For

Chiron is for people who want to spend as little time as possible typing into complicated phone menus during a workout.

The product direction is to reduce friction at the moment of capture:

- fast set logging during a workout
- voice-first input with typed fallback
- less menu navigation and less repetitive form entry
- structured workout data without a slow, admin-heavy logging flow

## Current Shape

The app is Android-first in day-to-day validation, with a local SQLite-backed data model and on-device transcription. The UI is built around a dashboard, an active-session capture screen, session history and detail screens, an exercise library, CSV import/export, and a small performance view.

## Development

Use the repo wrapper so the project does not depend on a globally installed Flutter SDK:

```bash
./scripts/flutterw --version
./scripts/flutterw doctor
```

## Running On A Device

- Android / GrapheneOS: enable developer options and USB debugging, then use `./scripts/flutterw run` or install a built APK
- iPhone: run locally through Flutter or Xcode with your own signing setup
