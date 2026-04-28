// lib/widgets/tcgc_logo.dart
import 'package:flutter/material.dart';
import '../theme.dart';

class TcgcLogo extends StatelessWidget {
  final double size;
  const TcgcLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: kWhite,
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        'assets/tcgc_logo.jpg',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          decoration: const BoxDecoration(
            color: kGreen,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.school, color: kWhite, size: size * 0.56),
        ),
      ),
    );
  }
}

class TcgcLogoSmall extends StatelessWidget {
  final double size;
  const TcgcLogoSmall({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: kWhite,
        shape: BoxShape.circle,
        border: Border.all(color: kGreen, width: 2),
      ),
      child: Image.asset(
        'assets/tcgc_logo.jpg',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          decoration: const BoxDecoration(
            color: kGreen,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.school, color: kWhite, size: size * 0.5),
        ),
      ),
    );
  }
}
