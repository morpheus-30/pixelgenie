import 'package:flutter/material.dart';

BoxDecoration kGradientBackgroundDecoration =const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF090979), Colors.black],
  ),
);

BoxDecoration kStarsBackgroundDecoration = const BoxDecoration(
  image: DecorationImage(
    image: AssetImage("assets/images/stasWBg.gif"),
    fit: BoxFit.cover,
  ),
);
