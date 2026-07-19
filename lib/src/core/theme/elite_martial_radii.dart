import 'package:flutter/widgets.dart';

abstract final class EliteMartialRadii {
  static const double sm = 4;
  static const double standard = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;

  static BorderRadius get card => BorderRadius.circular(lg);
  static BorderRadius get input => BorderRadius.circular(standard);
  static BorderRadius get pill => BorderRadius.circular(full);
}
