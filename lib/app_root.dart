import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mat3amy/core/routes/app_router.dart';
import 'package:mat3amy/core/utils/theme/themes.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.routes,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      builder: (_, child) => SafeArea(
        top: false,
        bottom: Platform.isAndroid,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: child!,
        ),
      ),
      theme: AppThemes.lightTheme,
    );
  }
}
