import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SportAppIconButton extends StatelessWidget {
  final Text text;
  final double height;
  final double width;
  final Color buttonColor;
  final void Function()? customOnPressed;
  final String imagePath;
  final double imageTopInset;
  final double imageLeftInset;
  final double imageRightInset;
  final double imageBottomInset;

  const SportAppIconButton({
    Key? key,
    required this.text,
    required this.height,
    required this.width,
    required this.buttonColor,
    this.customOnPressed,
    required this.imagePath,
    required this.imageTopInset,
    required this.imageLeftInset,
    required this.imageRightInset,
    required this.imageBottomInset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: text,
      icon: Padding(
        padding: EdgeInsets.only(
          right: imageRightInset,
          left: imageLeftInset,
          top: imageTopInset,
          bottom: imageBottomInset,
        ),
        child: SvgPicture.asset(
          imagePath,
          width: 24,
          height: 24,
        ),
      ),
      onPressed: customOnPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: buttonColor,
        elevation: 15,
        minimumSize: Size(width, height),
        primary: buttonColor,
        alignment: Alignment.centerLeft,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
    );
  }
}
