import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mat3amy/app_root.dart';
import 'package:mat3amy/core/services/local/shared_pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedPref.init();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('ar'),
      child: const MainApp(),
    ),
  );
}
