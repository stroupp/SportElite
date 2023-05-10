import 'package:flutter/material.dart';

class SportAppRoundedButton extends StatelessWidget {
  final String inputText;
  final double heightRatio;
  final Color buttonColor;
  final double widthRatio;
  final TextStyle textStyle;
  final Color borderColor;
  final void Function()? customOnPressed;
  const SportAppRoundedButton({
    Key? key,
    required this.inputText,
    required this.heightRatio,
    required this.widthRatio,
    required this.buttonColor,
    required this.textStyle,
    this.customOnPressed,
    required this.borderColor,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / widthRatio,
      height: MediaQuery.of(context).size.height / heightRatio,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
        color: buttonColor,
      ),
      child: MaterialButton(
        onPressed: customOnPressed,
        child: Text(
          inputText,
          style: textStyle,
        ),
      ),
    );
  }
}
