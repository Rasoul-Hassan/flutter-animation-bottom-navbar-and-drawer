import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class LanguageDropdown extends StatelessWidget {
  final String selectedCode;
  final Function(Locale) onLanguageSelected;

  const LanguageDropdown({
    super.key,
    required this.selectedCode,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    // Always rebuild list based on localization
    final List<Map<String, String>> languages = [
      {
        'code': 'es',
        'name': t.spanishLanguage,
        'flag': 'assets/flags/spain.png',
      },
      {
        'code': 'ar',
        'name': t.arabicLanguage,
        'flag': 'assets/flags/egypt.png',
      },
      {
        'code': 'en',
        'name': t.englishLanguage,
        'flag': 'assets/flags/British.png',
      },
      {
        'code': 'ku',
        'name': t.kurdishLanguage,
        'flag': 'assets/flags/Kurdistan.png',
      },
      {
        'code': 'fa',
        'name': t.persianLanguage,
        'flag': 'assets/flags/iran.png',
      },
    ];

    // find current selected language
    final current = languages.firstWhere(
      (lang) => lang['code'] == selectedCode,
      orElse: () => languages[2], // default English
    );

    return PopupMenuButton<String>(
      icon: Row(
        children: [
          Image.asset(current['flag']!, width: 24, height: 24),
          const SizedBox(width: 6),
          Text(current['name']!), // <-- localized current name
          const Icon(Icons.arrow_drop_down),
        ],
      ),
      initialValue: selectedCode,
      onSelected: (code) => onLanguageSelected(Locale(code)),
      itemBuilder: (_) => languages.map((lang) {
        return PopupMenuItem<String>(
          value: lang['code']!,
          child: Row(
            children: [
              Image.asset(lang['flag']!, width: 24, height: 24),
              const SizedBox(width: 8),
              Text(lang['name']!), // <-- localized
            ],
          ),
        );
      }).toList(),
    );
  }
}
