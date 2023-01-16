import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradeStar extends StatelessWidget {
  final int value;
  final double? size;

  const GradeStar({super.key, this.value = 0, this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
          color: Theme.of(context).colorScheme.secondary,
          size: size,
        );
      }),
    );
  }
}
