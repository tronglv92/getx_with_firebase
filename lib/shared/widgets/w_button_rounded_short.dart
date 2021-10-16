import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';

class WButtonRoundedShort extends StatelessWidget {
  const WButtonRoundedShort({required this.child,required this.onPressed});
  final Widget child;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: ColorConstants.colorOrange,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 0,
            fixedSize:  Size(85.W,55.H)),
        child: child);
  }
}
