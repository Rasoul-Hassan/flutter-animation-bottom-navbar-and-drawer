import 'package:flutter/material.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';

class KurdishMaterialLocalizations extends DefaultMaterialLocalizations {
  const KurdishMaterialLocalizations();

  @override
  String get okButtonLabel => 'باشە'; // OK
  @override
  String get cancelButtonLabel => 'هەڵوەشاندنەوە'; // Cancel
  @override
  String get closeButtonLabel => 'داخستن'; // Close
  @override
  String get continueButtonLabel => 'به‌رده‌وامبه‌'; // Continue
  @override
  String get backButtonTooltip => 'گەڕانەوە'; // Back
  // 👉 You can override more here if needed
}

class KurdishMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const KurdishMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return const KurdishMaterialLocalizations();
  }

  @override
  bool shouldReload(old) => false;
}
