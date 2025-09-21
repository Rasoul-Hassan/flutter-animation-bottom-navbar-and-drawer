import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:rive/rive.dart' hide Image;
import 'widgets/theme_switch.dart';
import 'side_menu.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/add_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'l10n/app_localizations.dart'; // ✅ import localization

/// ------------------- RIVE ICON MODEL -------------------
class TabItem {
  TabItem({this.stateMachine = "", this.artboard = ""});
  String stateMachine;
  String artboard;
  SMIBool? status;

  static List<TabItem> tabItemsList = [
    TabItem(stateMachine: "CHAT_Interactivity", artboard: "CHAT"),
    TabItem(stateMachine: "SEARCH_Interactivity", artboard: "SEARCH"),
    TabItem(stateMachine: "TIMER_Interactivity", artboard: "TIMER"),
    TabItem(stateMachine: "BELL_Interactivity", artboard: "BELL"),
    TabItem(stateMachine: "USER_Interactivity", artboard: "USER"),
  ];
}

/// ------------------- RIVE BOTTOM NAV ITEM -------------------
class RiveBottomNavItem extends StatefulWidget {
  final TabItem item;
  final bool isSelected;
  final VoidCallback onTap;
  const RiveBottomNavItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<RiveBottomNavItem> createState() => _RiveBottomNavItemState();
}

class _RiveBottomNavItemState extends State<RiveBottomNavItem> {
  SMIBool? _status;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      widget.item.stateMachine,
    );
    artboard.addController(controller!);
    _status = controller.findInput<bool>("active") as SMIBool;
  }

  @override
  void didUpdateWidget(covariant RiveBottomNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && _status != null) {
      _status!.change(true);
      Future.delayed(const Duration(milliseconds: 800), () {
        _status!.change(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 30,
        height: 30,
        child: RiveAnimation.asset(
          'assets/icons/icons.riv',
          artboard: widget.item.artboard,
          stateMachines: [widget.item.stateMachine],
          onInit: _onRiveInit,
        ),
      ),
    );
  }
}

/// ------------------- MAIN PAGE -------------------
class StartPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<Locale>? onLocaleChanged; // Add this line

  const StartPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    this.onLocaleChanged, // Add this line
  });

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _currentIndex = 0;
  String _selectedCode = 'en';

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const AddPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  Locale _getLocaleFromCode(String code) {
    switch (code) {
      case 'es':
        return const Locale('es');
      case 'ar':
        return const Locale('ar');
      case 'ku':
        return const Locale('ku');
      case 'fa':
        return const Locale('fa');
      default:
        return const Locale('en');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    // ✅ Localized language list
    final languages = [
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

    // current language
    final current = languages.firstWhere(
      (lang) => lang['code'] == _selectedCode,
      orElse: () => languages[2],
    );

    return Scaffold(
      drawer: const Drawer(child: SideMenu()), // Side menu
      appBar: AppBar(
        title: const Text('Theming Example'),
        actions: [
          PopupMenuButton<String>(
            icon: Row(
              children: [
                Image.asset(current['flag']!, width: 24, height: 24),
                const SizedBox(width: 6),
                Text(current['name']!), // ✅ localized
                const Icon(Icons.arrow_drop_down),
              ],
            ),
            onSelected: (code) {
              setState(() => _selectedCode = code);
              if (widget.onLocaleChanged != null) {
                final locale = _getLocaleFromCode(code);
                widget.onLocaleChanged!(locale);
              }
            },
            itemBuilder: (_) => languages.map((lang) {
              return PopupMenuItem<String>(
                value: lang['code']!,
                child: Row(
                  children: [
                    Image.asset(lang['flag']!, width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text(lang['name']!), // ✅ localized
                  ],
                ),
              );
            }).toList(),
          ),
          ThemeSwitch(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.primary,
        buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Colors.transparent,
        items: List.generate(TabItem.tabItemsList.length, (index) {
          final item = TabItem.tabItemsList[index];
          return RiveBottomNavItem(
            item: item,
            isSelected: _currentIndex == index,
            onTap: () {
              setState(() {
                _currentIndex = index;
              });
            },
          );
        }),
      ),
    );
  }
}
