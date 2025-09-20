import 'package:flutter/material.dart';

class LanguageDropdown extends StatefulWidget {
  final Function(String) onLanguageSelected;

  const LanguageDropdown({super.key, required this.onLanguageSelected});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  final List<Map<String, String>> _languages = [
    {'name': 'Spanish', 'flag': 'assets/flags/spain.png'},
    {'name': 'Arabic', 'flag': 'assets/flags/egypt.png'},
    {'name': 'English', 'flag': 'assets/flags/British.png'},
    {'name': 'Kurdish', 'flag': 'assets/flags/Kurdistan.png'},
    {'name': 'Persian', 'flag': 'assets/flags/iran.png'},
  ];

  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language, color: Colors.black),
      onSelected: (lang) {
        setState(() => _selectedLanguage = lang);
        widget.onLanguageSelected(lang);
      },
      itemBuilder: (_) => _languages
          .map(
            (lang) => PopupMenuItem<String>(
              value: lang['name']!,
              child: Row(
                children: [
                  Image.asset(lang['flag']!, width: 24, height: 24),
                  const SizedBox(width: 8),
                  Text(lang['name']!),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
