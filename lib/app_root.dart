import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mat3amy/core/routes/app_router.dart';
import 'package:mat3amy/core/utils/theme/themes.dart';
import 'package:mat3amy/features/auth/presentation/cubit/auth_cubit.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<AuthCubit>(create: (_) => AuthCubit())],
      child: MaterialApp.router(
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
      ),
    );
  }
}
