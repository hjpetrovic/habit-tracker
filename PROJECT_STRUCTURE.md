# Habit Tracker - Project Structure

## Overview
This document outlines the complete structure of the Habit Tracker Flutter application.

## Directory Structure

```
habit_tracker/
├── lib/
│   ├── models/                      # Data models
│   │   ├── habit.dart               # Habit model with id, name, color, createdDate, isActive
│   │   ├── daily_entry.dart         # DailyEntry model with habitId, date, isCompleted
│   │   └── models.dart              # Barrel file for models
│   │
│   ├── providers/                   # Riverpod state management
│   │   └── habit_providers.dart     # HabitListProvider, DailyEntriesProvider, ThemeProvider
│   │
│   ├── screens/                     # UI screens
│   │   ├── home_screen.dart         # Dashboard with habit list and contribution grids
│   │   ├── add_habit_screen.dart    # Form to add new habits with name and color
│   │   ├── habit_detail_screen.dart # Detail view with full calendar and edit functionality
│   │   └── settings_screen.dart     # Settings for theme toggle and app info
│   │
│   ├── widgets/                     # Reusable UI components
│   │   ├── habit_card.dart         # Card displaying habit with contribution grid
│   │   ├── contribution_grid.dart  # GitHub-style calendar grid component
│   │   └── color_picker_widget.dart # Color selection widget
│   │
│   ├── services/                    # Business logic and data persistence
│   │   ├── database_service.dart   # SQLite database operations
│   │   └── habit_service.dart       # High-level habit operations
│   │
│   ├── themes/                      # App theming
│   │   └── app_theme.dart           # Light and dark theme definitions
│   │
│   ├── utils/                       # Utility functions
│   │   └── colors.dart              # Color utilities and predefined habit colors
│   │
│   └── main.dart                    # App entry point with ProviderScope
│
├── android/                         # Android platform configuration
│   ├── app/
│   │   ├── build.gradle            # App-level Gradle configuration
│   │   └── src/main/
│   │       ├── AndroidManifest.xml # Android app manifest
│   │       └── kotlin/com/example/habit_tracker/
│   │           └── MainActivity.kt  # Android main activity
│   ├── build.gradle                # Project-level Gradle configuration
│   ├── settings.gradle              # Gradle settings
│   └── gradle.properties           # Gradle properties
│
├── ios/                             # iOS platform configuration
│   ├── Runner/
│   │   └── Info.plist              # iOS app info and permissions
│   └── Podfile                     # CocoaPods dependencies
│
├── test/                            # Test files
│   └── widget_test.dart             # Widget tests for the app
│
├── assets/                          # Asset files (empty for now)
│   ├── fonts/
│   └── images/
│
├── pubspec.yaml                     # Flutter dependencies and configuration
├── analysis_options.yaml            # Dart linter configuration
├── .gitignore                       # Git ignore rules
└── README.md                        # Project documentation

```

## Key Components

### Models
- **Habit**: Represents a habit with id, name, color (as int), creation date, and active status
- **DailyEntry**: Tracks completion status for a specific habit on a specific date

### State Management (Riverpod)
- **HabitListProvider**: Manages the list of habits with CRUD operations
- **DailyEntriesProvider**: Manages daily completion entries organized by habit and date
- **ThemeProvider**: Manages theme mode (light/dark)

### Services
- **DatabaseService**: Handles SQLite operations including schema creation and queries
- **HabitService**: High-level service that wraps database operations for habits

### Screens
1. **HomeScreen**: Dashboard showing all habits with 30-day contribution grids
2. **AddHabitScreen**: Form to create new habits with name and color selection
3. **HabitDetailScreen**: Full calendar view with edit/delete capabilities
4. **SettingsScreen**: Theme toggle and app information

### Widgets
- **HabitCard**: Displays habit info, streak, and contribution grid
- **ContributionGrid**: 30-day GitHub-style grid showing completion status
- **ColorPickerWidget**: Color selection from predefined palette

### Themes
- Complete light and dark theme implementations
- Custom color palette with primary, secondary, success, error colors
- Consistent typography and component styling

## Dependencies

```yaml
- flutter_riverpod: ^2.4.9    # State management
- sqflite: ^2.3.0             # Local database
- path: ^1.8.3                # Path utilities
- table_calendar: ^3.0.9      # Calendar widget
- flutter_colorpicker: ^1.0.3 # Color picker
- intl: ^0.18.1               # Date formatting
- uuid: ^4.3.3                # UUID generation
- cupertino_icons: ^1.0.6      # iOS icons
```

## Database Schema

### habits table
- id (TEXT, PRIMARY KEY)
- name (TEXT, NOT NULL)
- color (INTEGER, NOT NULL)
- createdDate (TEXT, NOT NULL)
- isActive (INTEGER, NOT NULL, DEFAULT 1)

### daily_entries table
- id (INTEGER, PRIMARY KEY, AUTOINCREMENT)
- habitId (TEXT, NOT NULL, FOREIGN KEY)
- date (TEXT, NOT NULL)
- isCompleted (INTEGER, NOT NULL, DEFAULT 0)

## Features Implemented

✅ Add habits with custom names and colors
✅ View all habits on dashboard
✅ GitHub-style contribution grid for each habit (30 days)
✅ Full calendar view with month navigation
✅ Toggle daily completion status
✅ Edit habit name and color
✅ Delete habits
✅ Local data persistence with SQLite
✅ Light/dark theme toggle
✅ Streak calculation
✅ Responsive UI for mobile screens
✅ Bottom navigation between Home and Settings

## Build Instructions

### Run on device/emulator:
```bash
flutter run
```

### Build Android APK:
```bash
flutter build apk
```

### Build iOS:
```bash
flutter build ios
```

### Run tests:
```bash
flutter test
```

## Notes

- The project uses Material Design 3
- Riverpod is used for state management
- SQLite provides local data persistence
- All data survives app restarts
- The app is designed for phone screens but is responsive
- No complex animations yet - focused on core functionality
