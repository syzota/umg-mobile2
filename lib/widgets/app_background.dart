import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final bool isDark;

  const AppBackground({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: isDark
                  ? const AssetImage("assets/images/bg_dark2.jpg")
                  : const AssetImage("assets/images/bg_light2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.25),
          ),
        ),
      ],
    );
  }
}
