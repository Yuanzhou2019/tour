import 'package:flutter/material.dart';

class AppShadow {
  AppShadow._();
  static const shadow1 = <BoxShadow>[
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];
  static const shadow2 = <BoxShadow>[
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  static const shadow3 = <BoxShadow>[
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
}
