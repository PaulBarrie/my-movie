

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradeStar extends StatelessWidget {
  final int value;  
  const GradeStar({super.key, this.value = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}