import 'package:flutter/material.dart';

class common_button extends StatelessWidget {
  final String lable_text;
  final Color lable_text_color;
  final Color backgroud_color;
  final double? width;
  final GestureTapCallback? onTap;

  const common_button(
      {Key? key,
      required this.lable_text,
      required this.backgroud_color,
      required this.lable_text_color,
      this.width,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        // height: 45,
        // width:(width ?? 300) ,
        decoration: BoxDecoration(
            color: backgroud_color, borderRadius: BorderRadius.circular(25)),
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: Text(
              lable_text,
              style: TextStyle(
                  color: lable_text_color, fontFamily: 'PR', fontSize: 16),
            )),
      ),
    );
  }
}
