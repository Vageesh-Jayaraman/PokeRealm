import 'dart:math';

import 'package:flutter/material.dart';

final List<Color> colors = [
  Color.fromARGB(255, 205, 250, 219),
  Color.fromARGB(255, 246, 253, 195),
  Color.fromARGB(255, 255, 207, 150),
  Color.fromARGB(255, 255, 128, 128),
  Color.fromARGB(255, 243, 204, 255),
  Color.fromARGB(255, 192, 222, 255),
  Color.fromARGB(255, 151, 231, 225),
  Color.fromARGB(255, 255, 229, 229),
];

final List<Color> darkColors = [
  Color.fromARGB(255, 51, 114, 83),
  Color.fromARGB(255, 106, 110, 84),
  Color.fromARGB(255, 136, 75, 75),
  Color.fromARGB(255, 136, 0, 0),
  Color.fromARGB(255, 63, 0, 63),
  Color.fromARGB(255, 0, 42, 49),
  Color.fromARGB(255, 0, 77, 75),
  Color.fromARGB(255, 92, 75, 75),
];

Color getColor({required int index}){
  return colors[ index % colors.length];
}

Color getDarkColor({required int index}){
  return darkColors[ index % darkColors.length];
}
