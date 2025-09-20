import 'package:flutter/material.dart';

class ThemeSwitch extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const ThemeSwitch({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          _isDark ? Icons.dark_mode : Icons.light_mode,
          color: _isDark ? Colors.amber : Colors.blueGrey,
        ),
        Switch(
          value: _isDark,
          onChanged: (value) {
            setState(() => _isDark = value);
            widget.onThemeChanged(value);
          },
        ),
      ],
    );
  }
}
