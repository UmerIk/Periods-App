import 'dart:ui';

import 'package:flutter/material.dart';

class CColors{

  static const blue = Color(0xFF54B0CC);
  static const pink = Color(0xFFEAA2DA);
  static const yellow = Color(0xFFF4BB19);
  static const brown = Color(0xFFD17928);

  static const bg = Color(0xFFECE9E7);
  static const icolor = Color(0xFFa8a8a8);

  static const textblack1 = Color(0xBf000000);
  static const textblack2 = Color(0x46000000);

  static const greens = Color(0xff92EB68);
  static const purples = Color(0xffD868EB);
  static const pinks = Color(0xffEB687F);
  static const golds = Color(0xffFFA800);
  static const gray = Color(0xfff4f4f4);



  static const darkestgray =  Color(0xFF808080);
  static const darkgray =  Color(0xFFA9A9A9);
  static const lightgray =  Color(0xFFD3D3D3);
  static const textblack = Color(0xFF242020);
  static const lightestgray =  Color(0xFFE0E0E0);
  static const textgray = Color(0xffB6B6B6);

  static Map<int, Color> getSwatch(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final lightness = hslColor.lightness;

    /// if [500] is the default color, there are at LEAST five
    /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
    /// divisor of 5 would mean [50] is a lightness of 1.0 or
    /// a color of #ffffff. A value of six would be near white
    /// but not quite.
    final lowDivisor = 6;

    /// if [500] is the default color, there are at LEAST four
    /// steps above [500]. A divisor of 4 would mean [900] is
    /// a lightness of 0.0 or color of #000000
    final highDivisor = 5;

    final lowStep = (1.0 - lightness) / lowDivisor;
    final highStep = lightness / highDivisor;

    return {
      50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
      200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
      300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
      400: (hslColor.withLightness(lightness + lowStep)).toColor(),
      500: (hslColor.withLightness(lightness)).toColor(),
      600: (hslColor.withLightness(lightness - highStep)).toColor(),
      700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
      800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
      900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
    };
  }
}