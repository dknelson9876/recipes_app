import 'package:flutter/material.dart';

class ThemeModeSwitcher extends StatefulWidget {
  ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  ThemeModeSwitcher({
    Key? key,
    required this.themeMode,
    required this.onThemeModeChanged,
  }) : super(key: key);

  @override
  State<ThemeModeSwitcher> createState() => _ThemeModeSwitcherState();
}

class _ThemeModeSwitcherState extends State<ThemeModeSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.light_mode),
        const SizedBox(width: 8),
        const Text('Theme'),
        const Spacer(),
        DropdownButton<ThemeMode>(
          value: widget.themeMode,
          icon: const Icon(Icons.arrow_downward),
          onChanged: (ThemeMode? newMode) {
            widget.themeMode = newMode!;
            widget.onThemeModeChanged(newMode);
            setState(() {});
          },
          items: const <DropdownMenuItem<ThemeMode>>[
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('Light'),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('Dark'),
            ),
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('System default'),
            ),
          ],
        ),
      ],
    );
  }
}
