// lib/widgets/tcgc_logo.dart
import 'package:flutter/material.dart';
import '../theme.dart';

/// Shows the actual TCGC school logo image.
/// Falls back to a green school icon if the image fails to load.
class TcgcLogo extends StatelessWidget {
  final double size;
  const TcgcLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: kWhite,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/tcgc_logo.jpg',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          color: kGreen,
          child: Icon(Icons.school, color: kWhite, size: size * 0.56),
        ),
      ),
    );
  }
}

/// Small inline logo for sidebars and headers (circular, with green bg ring)
class TcgcLogoSmall extends StatelessWidget {
  final double size;
  const TcgcLogoSmall({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: kWhite,
        shape: BoxShape.circle,
        border: Border.all(color: kGreen, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/tcgc_logo.jpg',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          color: kGreen,
          child: Icon(Icons.school, color: kWhite, size: size * 0.5),
        ),
      ),
    );
  }
}
