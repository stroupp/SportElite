import 'package:flutter/material.dart';

Color kGreenColor = Color(0xff58DC84);

clearCash() {
  PaintingBinding.instance!.imageCache!.clear();
  PaintingBinding.instance!.imageCache!.clearLiveImages();
}
