import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'models/menu_row.dart';
import 'dart:math';
import 'models/menu_item.dart';
import 'theme.dart';
import 'assets.dart' as app_assets;
import 'l10n/app_localizations.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final List<MenuItemModel> _browseMenuIcons = MenuItemModel.menuItems;
  final List<MenuItemModel> _historyMenuIcons = MenuItemModel.menuItems2;
  final List<MenuItemModel> _themeMenuIcon = MenuItemModel.menuItems3;
  String _selectedMenu = MenuItemModel.menuItems[0].title;
  bool _isDarkMode = false;

  void onThemeRiveIconInit(artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      _themeMenuIcon[0].riveIcon.stateMachine,
    );
    artboard.addController(controller!);
    _themeMenuIcon[0].riveIcon.status =
        controller.findInput<bool>("active") as SMIBool;
  }

  void onMenuPress(MenuItemModel menu) {
    setState(() {
      _selectedMenu = menu.title;
    });
  }

  void onThemeToggle(value) {
    setState(() {
      _isDarkMode = value;
    });
    _themeMenuIcon[0].riveIcon.status!.change(value);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!; // localized strings

    return Container(
      width: 260,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: max(0, MediaQuery.of(context).padding.bottom - 60),
      ),
      constraints: const BoxConstraints(maxWidth: 288),
      decoration: BoxDecoration(color: RiveAppTheme.background2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------- User Profile Header -----------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.person_outline),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rasoul",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: "Inter",
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.softwareEngineer, // localized job title
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 15,
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ----------- Menu Sections -----------
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MenuButtonSection(
                    title: t.browse, // localized section title
                    selectedMenu: _selectedMenu,
                    menuIcons: _browseMenuIcons,
                    onMenuPress: onMenuPress,
                  ),
                  MenuButtonSection(
                    title: t.history, // localized section title
                    selectedMenu: _selectedMenu,
                    menuIcons: _historyMenuIcons,
                    onMenuPress: onMenuPress,
                  ),
                ],
              ),
            ),
          ),
          // ----------- Theme Toggle -----------
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Opacity(
                    opacity: 0.6,
                    child: RiveAnimation.asset(
                      app_assets.iconsRiv,
                      stateMachines: [_themeMenuIcon[0].riveIcon.stateMachine],
                      artboard: _themeMenuIcon[0].riveIcon.artboard,
                      onInit: onThemeRiveIconInit,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    t.theme, // localized theme label
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                CupertinoSwitch(value: _isDarkMode, onChanged: onThemeToggle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------- Menu Section Widget -----------
class MenuButtonSection extends StatelessWidget {
  const MenuButtonSection({
    super.key,
    required this.title,
    required this.menuIcons,
    this.selectedMenu = "Home",
    this.onMenuPress,
  });

  final String title;
  final String selectedMenu;
  final List<MenuItemModel> menuIcons;
  final Function(MenuItemModel menu)? onMenuPress;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!; // ✅ for translations

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 40,
            bottom: 8,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 15,
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (var menu in menuIcons) ...[
                Divider(
                  color: Colors.white.withOpacity(0.1),
                  thickness: 1,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                MenuRow(
                  menu: menu,
                  selectedMenu: selectedMenu,
                  onMenuPress: () => onMenuPress?.call(menu),
                  title: () {
                    switch (menu.title.toLowerCase()) {
                      case "home":
                        return t.home;
                      case "search":
                        return t.search;
                      case "favorites":
                        return t.favorites;
                      case "help":
                        return t.help;
                      case "history":
                        return t.history;
                      case "notification":
                        return t.notifications;
                      case "dark mode":
                        return t.theme;
                      default:
                        return menu.title;
                    }
                  }(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
