import 'package:flutter/material.dart';
import '../theme/noon_theme.dart';

class NoonExpressBadge extends StatelessWidget {
  final double fontSize;

  const NoonExpressBadge({
    super.key,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: NoonTheme.yellowPrimary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'noon',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: NoonTheme.noonBlack,
              letterSpacing: -0.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(width: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            decoration: BoxDecoration(
              color: NoonTheme.noonBlack,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              'express',
              style: TextStyle(
                fontSize: fontSize - 1,
                fontWeight: FontWeight.bold,
                color: NoonTheme.yellowPrimary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
