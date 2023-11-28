import 'package:flutter/material.dart';

abstract class DragableWidgetChild {}

class DragableWidgetTextChild extends DragableWidgetChild {
  DragableWidgetTextChild({
    required this.text,
    this.textAlign,
    this.fontFamily,
    this.color = Colors.white,
    this.fontSize = 16,
    this.fontStyle,
    this.fontWeight,
  });

  String text;
  TextAlign? textAlign;
  Color? color;
  double? fontSize;
  String? fontFamily;
  FontStyle? fontStyle;
  FontWeight? fontWeight;

  DragableWidgetTextChild copyWith({
    String? text,
    TextAlign? textAlign,
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontStyle? fontStyle,
    FontWeight? fontWeight,
  }) {
    return DragableWidgetTextChild(
      text: text ?? this.text,
      textAlign: textAlign ?? this.textAlign,
      fontFamily: fontFamily ?? this.fontFamily,
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
      fontStyle: fontStyle ?? this.fontStyle,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }
}
