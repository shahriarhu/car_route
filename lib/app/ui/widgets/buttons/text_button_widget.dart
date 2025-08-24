import 'package:car_route/app/ui/widgets/texts/titles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: TitleSmall(text: label, color: Get.theme.primaryColor),
    );
  }
}
