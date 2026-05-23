import 'package:flutter/material.dart';
	extension AppExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  Size get screenSize => MediaQuery.of(this).size;
}
