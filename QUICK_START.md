# Quick Start Guide - Habit Tracker Flutter App

## Prerequisites
Before running the app, ensure you have:
- Flutter SDK installed (stable channel)
- Android Studio or Xcode for platform-specific builds
- A physical device or emulator/simulator

## Setup Instructions

### 1. Install Dependencies
Navigate to the project directory and install Flutter dependencies:

```bash
cd /home/engine/project
flutter pub get
```

This will download all required packages:
- flutter_riverpod
- sqflite
- table_calendar
- flutter_colorpicker
- intl
- uuid
- And other dependencies

### 2. Verify Flutter Setup
Check that your Flutter environment is properly configured:

```bash
flutter doctor
```

Ensure all required tools are installed and configured.

### 3. Run the App

#### On Connected Device/Emulator:
```bash
flutter run
```

#### Specific Device:
```bash
flutter devices                    # List available devices
flutter run -d <device-id>         # Run on specific device
```

#### Chrome/Web (for testing):
```bash
flutter run -d chrome
```

## First Time Usage

1. **App Launch**: The app will open showing an empty dashboard
2. **Add Your First Habit**: 
   - Tap the `+` floating action button
   - Enter a habit name (e.g., "Exercise", "Read", "Meditate")
   - Select a color from the color picker
   - Tap "Save Habit"

3. **Track Progress**:
   - Your habit appears on the dashboard with a 30-day grid
   - Tap on the habit card to view the full calendar
   - Tap any day to toggle it as complete/incomplete

4. **View Details**:
   - Tap on a habit card to see details
   - View full calendar with month navigation
   - Edit habit name or color
   - Delete habit if needed

5. **Settings**:
   - Tap the "Settings" tab in bottom navigation
   - Toggle between light and dark theme
   - View app information

## Building for Production

### Android APK:
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (Play Store):
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS:
```bash
flutter build ios --release
```

## Running Tests

### Run all tests:
```bash
flutter test
```

### Run specific test file:
```bash
flutter test test/widget_test.dart
```

### Run with coverage:
```bash
flutter test --coverage
```

## Common Issues

### Issue: "Flutter command not found"
**Solution**: Ensure Flutter is in your PATH
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### Issue: "sqflite plugin not working on web"
**Solution**: sqflite is mobile-only. For web testing, use Chrome but note database features won't work.

### Issue: "Gradle build failed"
**Solution**: 
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Issue: "Pod install failed" (iOS)
**Solution**:
```bash
cd ios
pod install
cd ..
```

## Project Structure Summary

```
habit_tracker/
├── lib/
│   ├── main.dart              # App entry point
│   ├── models/                # Data models
│   ├── providers/             # Riverpod state management
│   ├── screens/               # UI screens (4 screens)
│   ├── widgets/               # Reusable components (3 widgets)
│   ├── services/              # Database and business logic
│   ├── themes/                # App theming
│   └── utils/                 # Helper utilities
├── android/                   # Android platform files
├── ios/                       # iOS platform files
├── test/                      # Test files
└── pubspec.yaml              # Dependencies and config
```

## Key Features

✅ **Habit Management**
- Add habits with custom names and colors
- Edit existing habits
- Delete habits with confirmation

✅ **Tracking**
- Daily completion toggle
- 30-day GitHub-style contribution grid
- Full calendar view with month navigation
- Streak calculation

✅ **Persistence**
- SQLite database for local storage
- Data survives app restarts
- Automatic schema creation

✅ **UI/UX**
- Material Design 3
- Light and dark themes
- Bottom navigation
- Responsive design
- Smooth animations

✅ **State Management**
- Riverpod for clean state management
- Providers for habits, entries, and theme
- Loading and error states

## Development Tips

### Hot Reload
While the app is running, make changes and press:
- `r` in the terminal for hot reload
- `R` for hot restart
- `q` to quit

### Debugging
- Use `print()` statements for debugging
- Use Flutter DevTools for advanced debugging:
  ```bash
  flutter pub global activate devtools
  flutter pub global run devtools
  ```

### Code Style
The project follows Flutter/Dart conventions:
- Use `const` constructors where possible
- Follow naming conventions (camelCase, PascalCase)
- Organize imports alphabetically
- Use meaningful variable and function names

## Next Steps

Once comfortable with the basics, you can:
1. Add more features (reminders, notifications, statistics)
2. Enhance the UI with animations
3. Add charts for progress visualization
4. Implement habit categories
5. Add export/import functionality
6. Integrate with cloud backup

## Support

For issues or questions:
- Check the README.md for detailed documentation
- Review PROJECT_STRUCTURE.md for architecture details
- See SETUP_COMPLETE.md for verification checklist

---

**Happy Habit Tracking! 🎯**
