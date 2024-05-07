// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class RoundButtonWidget extends StatelessWidget {
  String title;
  final VoidCallback onTap;
  double width;
  double height;

  bool loading;
  RoundButtonWidget(
      {super.key,
      required this.title,
      required this.onTap,
      this.width = 300,
      this.height = 50,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 3, color: Colors.white)
              : Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
        ),
      ),
    );
  }
}
