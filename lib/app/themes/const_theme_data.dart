import 'package:flutter/material.dart';

class ConstantThemeData {
  OutlineInputBorder onFocusOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: Colors.green,
      width: 3,
    ),
  );
  Color primaryColour = Colors.green;
  Color shadowColor = Colors.transparent;
  Color drawerAppBarLightColor = Colors.green;
  Color drawerAppBarDarkColor = Colors.grey.shade700;
  Color navbarColorLight = Colors.grey.shade300;
  Color navbarColorDark = Colors.grey.shade800;
}
