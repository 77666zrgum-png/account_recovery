import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('ar', ''),
    Locale('en', '')
  ];

  String get welcomeMessage => locale.languageCode == 'ar' ? 'مرحباً بك مجدداً' : 'Welcome Back';
  String get loginButton => locale.languageCode == 'ar' ? 'تسجيل الدخول' : 'Login';
  String get recoverAccount => locale.languageCode == 'ar' ? 'استعادة الحساب' : 'Recover Account';
}
