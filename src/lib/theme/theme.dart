import 'package:flutter/material.dart';
final colorScheme1 = ColorScheme.fromSeed(seedColor: Colors.blueAccent);
final theme1 = 
  ThemeData(
  colorScheme: colorScheme1,
  cardTheme: CardThemeData(
    color: ThemeData.light().dialogTheme.backgroundColor,
  ),
  navigationRailTheme: NavigationRailThemeData(
    backgroundColor: colorScheme1.surfaceContainer,
  ),
  //scaffoldBackgroundColor: const Color.fromARGB(255, 226, 228, 230),
  appBarTheme: AppBarTheme(
    backgroundColor: colorScheme1.primary,
    foregroundColor: colorScheme1.onPrimary,
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0.0,
        ),
  useMaterial3: true,
  dividerColor: Colors.black26,
  // // textTheme: const TextTheme(
  // //   bodyMedium: TextStyle(
  // //     color: Colors.blueAccent,
  // //     fontWeight: FontWeight.w500,
  // //     fontSize: 20,
  // //   ),
  // //   labelSmall: TextStyle(
  // //     color: Colors.black26,
  // //     fontWeight: FontWeight.w700,
  // //     fontSize: 14,
  // //   ),
  // ),
);
