import 'package:flutter/material.dart';

const bgColor = Color(0xFFF2FFEB);
const darkbgColor = Color(0xFFE2FFD2);
const elementColor = Color(0xFFA7CF9B);
const darkelementColor = Color(0xFF89b97a);
const selectColor = Color(0xFF567B59);
const defaultPadding = 20.0;

enum SortLabel {
  cheap(1, 'Сначала недорогие'),
  expensive(2, 'Сначала дорогие'),
  popular(3, 'Сначала популярные'),
  sale(4, 'По скидке (%)');

  const SortLabel(this.number, this.value);
  final int number;
  final String value;
}
