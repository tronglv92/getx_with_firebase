import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';

class AButtonRoundedLong extends StatelessWidget {
  const AButtonRoundedLong(
      {required this.child,
      required this.onPress,
      this.borderRadius,
      this.primary,
      this.padding,
      Key? key})
      : super(key: key);

  final Widget child;
  final Function onPress;
  final double? borderRadius;
  final Color? primary;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          onPress();
        },
        style: ElevatedButton.styleFrom(
          primary: primary ?? ColorConstants.colorOrange,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 30)),
          elevation: 0,
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 15.H, horizontal: 20.W),
        ),
        child: Center(child: child));
  }
}
