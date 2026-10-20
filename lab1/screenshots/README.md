# Required screenshots

Save genuine screenshots from the running PaceMate app in this directory:

| Filename | Capture |
| --- | --- |
| `phone-light.png` | Runs tab in a phone-sized emulator with the Light theme selected. |
| `phone-dark.png` | Runs tab in the same phone-sized emulator with the Dark theme selected. |
| `tablet-grid.png` | Runs tab in a tablet-sized emulator wide enough to display the grid. |

To capture them manually, run `flutter run` from the `lab1` directory and select a phone or tablet emulator. For the light and dark images, choose the theme from the Profile tab, return to Runs, and use the emulator's screenshot control. For the tablet image, use a tablet emulator whose available Runs area is at least 600 logical pixels wide, then save a screenshot while the grid is visible. Keep the screenshots in this directory using the filenames above.

No screenshot files are included yet. Although Chrome is available as a Flutter target, Flutter reports that screenshots are unsupported for Chrome in this environment, and the current UI session does not expose a capturable app window. These placeholders describe the needed captures; they are not screenshots of the app.
