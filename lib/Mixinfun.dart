import 'package:flutter/material.dart';

mixin GlobalFun {
  Widget Text1(String string, double size, FontWeight fontWeight,){
    return Text(
      string,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: size,
      ),
    );
  }
}