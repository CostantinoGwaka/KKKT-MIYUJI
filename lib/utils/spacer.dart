import 'package:flutter/material.dart';

///space between product alignment [height]
Widget manualStepper({int step = 5}) {
  return SizedBox(height: step.toDouble());
}

Widget manualSpacer({int step = 5}) {
  return SizedBox(
    width: step.toDouble(),
  );
}

///dynamic device height
double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

///dynamic device width
double deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

//physics
ScrollPhysics physics = const BouncingScrollPhysics();
