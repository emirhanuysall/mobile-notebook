import 'dart:async';
import 'package:firebase_crud/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Function()? onPressed;
  final String text;
  final Duration throttleDuration;

  const CustomButton({
    Key? key,
    this.onPressed,
    required this.text,
    this.throttleDuration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isButtonEnabled = true;

  void _handleButtonPress() {
    if (isButtonEnabled) {
      widget.onPressed?.call(); // onPressed fonksiyonunu çağır

      setState(() {
        isButtonEnabled = false;
      });

      Timer(widget.throttleDuration, () {
        if (mounted) {
          // Widget hala aktifse setState çağır
          setState(() {
            isButtonEnabled = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _handleButtonPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: KColors.primaryColor,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }
}
