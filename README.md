# Habit Tracker

A simple and effective habit tracking application built with Flutter.

## Features

- ✅ Add custom habits with names and colors
- ✅ Track daily completion status with calendar view
- ✅ GitHub-style contribution grid for quick overview
- ✅ Edit and delete habits
- ✅ Dark/Light theme toggle
- ✅ Streak tracking
- ✅ Local data persistence with SQLite

## Project Structure

```
lib/
├── models/              # Data models
│   ├── habit.dart
│   ├── daily_entry.dart
│   └── models.dart
├── providers/           # State management (Riverpod)
│   └── habit_providers.dart
├── screens/             # UI screens
│   ├── home_screen.dart
│   ├── add_habit_screen.dart
│   ├── habit_detail_screen.dart
│   └── settings_screen.dart
├── widgets/            # Reusable components
│   ├── habit_card.dart
│   ├── contribution_grid.dart
│   └── color_picker_widget.dart
├── services/           # Business logic
│   ├── database_service.dart
│   └── habit_service.dart
├── themes/             # App theming
│   └── app_theme.dart
├── utils/              # Helper utilities
│   └── colors.dart
└── main.dart           # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK
- Android Studio / Xcode (for mobile builds)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Building

#### Android APK
```bash
flutter build apk
```

#### iOS
```bash
flutter build ios
```

## Dependencies

- **flutter_riverpod**: State management
- **sqflite**: Local database storage
- **table_calendar**: Calendar widget
- **flutter_colorpicker**: Color selection
- **intl**: Date formatting
- **uuid**: Unique ID generation

## Usage

1. **Add a Habit**: Tap the + button on the home screen, enter a name and select a color
2. **Track Progress**: Tap on a day in the calendar to mark it as complete
3. **View Details**: Tap on a habit card to see the full calendar and edit details
4. **Delete Habit**: Use the delete button on the habit card or detail screen
5. **Toggle Theme**: Go to Settings and switch between light and dark mode

## Development

### Running Tests
```bash
flutter test
```

### Code Style
The project follows Flutter/Dart conventions with:
- `prefer_const_constructors`
- `prefer_const_literals_to_create_immutables`
- `sort_pub_dependencies` (disabled for flexibility)

## License

MIT License
