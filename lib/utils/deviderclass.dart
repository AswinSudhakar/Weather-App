import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Color color;
  final double thickness;
  final double height;
  final double indent;
  final double endIndent;

  // Constructor
  const CustomDivider({
    Key? key,
    this.color = Colors.black,
    this.thickness = 2.0,
    this.height = 20.0,
    this.indent = 0.0,
    this.endIndent = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height),
      child: Divider(
        color: color,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
      ),
    );
  }
}
