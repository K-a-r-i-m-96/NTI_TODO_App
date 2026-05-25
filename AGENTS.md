# AGENTS.md

## Architecture Overview
This is a Flutter task management app with a simple screen-based navigation structure. No backend integration; all data is stored in-memory using `List<Map<String, String>>` in `HomeView`. Key screens: `SplashView` → `StartView` → `RegisterView` → `LoginView` → `HomeView` (main tasks screen). See `lib/main.dart` for app initialization with `ScreenUtilInit` (design size 375x812).

## Navigation Patterns
Uses `Navigator.push`/`pushReplacement`/`pushAndRemoveUntil` for screen transitions. Results passed back via `Navigator.pop(result)`. Example: `AddTaskScreen` returns `Map<String, String>` with task data, handled in `HomeView._handleTaskActionResult`. Edit screens return actions like `{'action': 'update', 'index': 0, 'task': {...}}`.

## Data Management
Tasks stored as `List<Map<String, String>>` with keys: `title`, `description`, `group`, `date`, `isDone`. No persistence; data resets on app restart. Groups predefined: `['Home', 'Personal', 'Work']` with asset icons in `assets/images/`. See `lib/home.dart` for CRUD operations.

## UI Patterns
- Responsive design using `flutter_screenutil` (e.g., `334.w` for width).
- Consistent styling: `Color(0xFF1B9E5A)` for primary green, `GoogleFonts.lexendDeca` for text.
- Custom text fields with rounded borders, shadows, and focus colors. Example in `lib/add_task.dart._buildTextField`.
- Date/time picker with custom format: `"${pickedDate.day} ${months[pickedDate.month - 1]}, ${pickedDate.year}    $hour:$minute $period"`.
- Image pickers using `image_picker` for profile images.

## Validation & Forms
Login uses regex: username `r'^[a-zA-Z0-9]{3,20}$`, password `r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$'`. Form validation with `Form` and `TextFormField`. See `lib/login.dart`.

## Workflows
- **Build/Run**: Standard Flutter commands (`flutter pub get`, `flutter run`). No custom scripts.
- **Assets**: Images in `assets/images/`, declared in `pubspec.yaml` as `assets: - assets/images/`.
- **Dependencies**: Key packages: `dio` (unused), `image_picker`, `flutter_svg`, `flutter_screenutil`, `google_fonts`.
- **Debugging**: Use Flutter DevTools; no custom logging.

## Key Files
- `lib/home.dart`: Main tasks screen with list, add/edit/delete logic.
- `lib/add_task.dart`: Task creation with group dropdown, date picker.
- `lib/edit_task.dart`: Task editing, marking done, deletion.
- `lib/profile.dart`: User menu navigation.
- `pubspec.yaml`: Dependencies and assets config.</content>
<parameter name="filePath">C:\Programming\NTI\Flutter_NTI\AGENTS.md
