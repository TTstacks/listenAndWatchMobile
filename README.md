# ListenAndWatch Mobile

A cross-platform mobile application built with **Flutter** for managing and consuming media content (listening and watching). This is the mobile companion to [listenAndWatch](https://github.com/TTstacks/listenAndWatch), the web frontend.

## Tech Stack

- **Framework:** Flutter / Dart
- **Platforms:** Android, iOS, Web, macOS, Linux, Windows
- **Language breakdown:** Dart (37%), C++ (32%), CMake (24%), Swift (3%)

## Project Structure

```
listenAndWatchMobile/
├── lib/            # Dart source code (UI, business logic)
├── android/        # Android-specific native files
├── ios/            # iOS-specific native files
├── web/            # Web target files
├── macos/          # macOS target files
├── linux/          # Linux target files
├── windows/        # Windows target files
├── assets/
│   └── icon/       # App icons
├── pubspec.yaml    # Flutter dependencies and config
└── analysis_options.yaml
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel recommended)
- Android Studio or Xcode (for mobile targets)
- A connected device or emulator

### Installation

```bash
git clone https://github.com/TTstacks/listenAndWatchMobile.git
cd listenAndWatchMobile
flutter pub get
```

### Run the App

```bash
# Run on a connected device or emulator
flutter run

# Run on a specific platform
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

### Build

```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

### Tests

```bash
flutter test
```

## Related Repositories

- **Web Frontend:** [listenAndWatch](https://github.com/TTstacks/listenAndWatch) — Angular desktop web app

## Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
