import 'package:flutter/material.dart';

class ApppText extends StatelessWidget {
  String? data;
  double? size;
  Color? color;
  FontWeight? fw;
  TextAlign? align;
  ApppText(
      {Key? key,
      required this.data,
      this.size,
      this.color,
      this.fw,
      this.align = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      data.toString(),
      textAlign: align,
      style: TextStyle(fontSize: size, color: color, fontWeight: fw),
    );
  }
}
