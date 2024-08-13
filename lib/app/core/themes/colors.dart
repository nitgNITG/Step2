import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff002E94);
const kSecondaryColor = Color(0xff00FFFF);
const kOnPrimary = Colors.white;
ColorScheme getLightColorScheme() {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: kPrimaryColor,
    onPrimary: Colors.white,
    secondary: kSecondaryColor,
    onSecondary: kPrimaryColor,
    error: Colors.red,
    onError: Colors.white,
    background: Colors.white,
    onBackground: kPrimaryColor,
    surface: Color.fromARGB(255, 255, 255, 255),
    shadow: kPrimaryColor,
    onSurface: kSecondaryColor,
  );
}

ColorScheme getDarkColorScheme() {
  return const ColorScheme(
    brightness: Brightness.dark,
    primary: kPrimaryColor,
    onPrimary: Colors.white,
    secondary: kSecondaryColor,
    onSecondary: kPrimaryColor,
    error: Colors.red,
    onError: Colors.white,
    background: Color(0xff001B58),
    onBackground: kOnPrimary,
    surface: kPrimaryColor,
    surfaceTint: kOnPrimary,
    shadow: kOnPrimary,
    onSurface: Colors.white,
  );
}
