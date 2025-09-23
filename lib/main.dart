import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'start_page.dart';
import '../app_preferences.dart';
import 'kurdish_material_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDark = await AppPreferences.getDarkMode();
  final locale = await AppPreferences.getLocale();
  runApp(MyApp(isDarkMode: isDark, initialLocale: locale));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  final Locale initialLocale;
  const MyApp({
    super.key,
    required this.isDarkMode,
    required this.initialLocale,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;
  late Locale _locale; // default locale

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _locale = widget.initialLocale;
  }

  // ----- choose font by locale -----
  String _getFontFamily(Locale locale) {
    final code = locale.languageCode;
    if (code == 'ar' || code == 'fa' || code == 'ku') {
      return 'NotoKufiArabic';
    }
    if (code == 'es') {
      return 'ShareTech';
    }
    return 'BebasNeue';
  }

  @override
  Widget build(BuildContext context) {
    final currentFont = _getFontFamily(_locale);

    final lightTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: currentFont, // <-- correct place to set global font
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2fe49a),
        foregroundColor: Color(0xFF0a0808),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF2fe49a),
        selectedItemColor: Color(0xFFf3e200),
        unselectedItemColor: Colors.grey,
      ),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      fontFamily: currentFont, // <-- correct place for dark theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0a0808),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0a0808),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Localization
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        KurdishMaterialLocalizationsDelegate(), // 👈 Add this
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('ar'),
        Locale('fa'),
        Locale('ku'),
      ],

      // Themes with dynamic font
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Pass callbacks to StartPage
      home: StartPage(
        isDarkMode: _isDarkMode,
        onThemeChanged: (val) async {
          setState(() => _isDarkMode = val);
          await AppPreferences.setDarkMode(val); // ✅ save
        },
        onLocaleChanged: (locale) async {
          setState(() => _locale = locale);
          await AppPreferences.setLocale(locale); // ✅ save
        },
      ),
    );
  }
}
