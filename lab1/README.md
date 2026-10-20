# PaceMate Running Club

PaceMate is a Flutter app for a running club to plan group runs across paces, distances, and locations. Runners can find sessions, see who is attending, and manage their own participation.

## Features

- **Runs:** Search by title or location, filter by category and past/upcoming status, view availability, and open run details.
- **Favourites:** Keep a separate view of runs marked as favourites.
- **Profile:** Edit your name and running group, check how many run lists include you, and choose the app theme.
- Run details include the meeting information, participants, and join/leave actions.
- Create, edit, and delete runs. Data stays in memory for the current app session.
- Responsive run cards use a list on narrow screens and a grid on wider screens.

## Setup and run

Install Flutter and confirm that `flutter doctor` reports a working development target. From PowerShell, run:

```powershell
cd C:\flutter-2026-bekzat\lab1
flutter pub get
flutter run
```

Choose a connected emulator, device, or desktop/web target when Flutter prompts for one.

## Decisions

The app shell owns the run list and profile in memory so each tab and detail route sees the same current data. Screens receive model values and callbacks through constructors, while the create/edit form returns an `Item` through its typed route result and the shell updates its list only when the result is non-null. `LayoutBuilder` selects the list or grid from the width actually available to the run list, rather than guessing from a device type or screen size. The form's `PopScope` allows a clean form to close directly and checks whether a dirty form needs discard confirmation before leaving. `MyApp` owns the selected `ThemeMode`, and the Profile theme chips change it through a callback. This version deliberately uses in-memory state and does not add persistence or a state-management package. If Week 9 introduces state-management or persistence tools, the shell's state could move behind those tools while constructor data and typed form results continue to define the screen boundaries.

## Screenshots

Screenshot capture instructions and the expected filenames are in [`screenshots/README.md`](screenshots/README.md).
