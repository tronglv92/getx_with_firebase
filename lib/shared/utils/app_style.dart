import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/constants/common.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
/// Black text style - w900
TextStyle blackTextStyle(
  double size, {
  Color? color,
  double? height,
  String? fontFamily,
}) =>
    thinTextStyle(size, color: color, height: height).copyWith(
      fontWeight: FontWeight.w900,
      fontFamily: fontFamily,
    );

/// Extra-bold text style - w800
TextStyle extraBoldTextStyle(
  double? size, {
  Color? color,
  double? height,
  String? fontFamily,
}) =>
    thinTextStyle(size, color: color, height: height).copyWith(
      fontWeight: FontWeight.w800,
      fontFamily: fontFamily,
    );

/// Bold text style - w700
TextStyle boldTextStyle(
  double? size, {
  Color? color,
  double? height,
  String? fontFamily,
}) =>
    thinTextStyle(size, color: color, height: height).copyWith(
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
    );

/// Semi-bold text style - w600
TextStyle semiBoldTextStyle(
  double? size, {
  Color? color,
  double? height,
  String? fontFamily,
}) =>
    thinTextStyle(size, color: color, height: height).copyWith(
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily,
    );

/// Medium text style - w500
TextStyle mediumTextStyle(
  double? size, {
  Color? color,
  double? height,
  String? fontFamily,
}) =>
    thinTextStyle(size, color: color, height: height).copyWith(
      fontWeight: FontWeight.w500,
      fontFamily: fontFamily,
    );

/// Normal text style - w400
TextStyle normalTextStyle(
  double? size, {
  Color? color,
  double? height = 1.1,
  String? fontFamily,
}) =>
    thinTextStyle(size, color: color, height: height).copyWith(
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily,
    );

/// Light text style - w300
TextStyle lightTextStyle(
  double? size, {
  Color? color,
  double? height,
  String? fontFamily,
}) =>
    thinTextStyle(size, color: color, height: height).copyWith(
      fontWeight: FontWeight.w300,
      fontFamily: fontFamily,
    );

/// Extra-light text style - w200
TextStyle extraLightTextStyle(
  double? size, {
  Color? color,
  double? height,
  String? fontFamily,
}) =>
    thinTextStyle(size, color: color, height: height).copyWith(
      fontWeight: FontWeight.w200,
      fontFamily: fontFamily,
    );

/// Thin text style - w100
TextStyle thinTextStyle(
  double? size, {
  Color? color,
  double? height,
  String ?fontFamily,
}) =>
    TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w100,
      fontFamily: fontFamily,
      color: color,
      height: height,
    );
TextStyle txt32BoldRoboto({Color? color,double? height})=>  TextStyle(
  fontSize: 32.SP,
  fontWeight: FontWeight.w700,
  fontFamily: FontConstants.fontRoboto,
  color: color?? Colors.black,
  height: height,
);
TextStyle txt18RegularRoboto({Color? color,double? height})=>  TextStyle(
  fontSize: 18.SP,
  fontWeight: FontWeight.w400,
  fontFamily: 'Roboto',
  color: color?? Colors.black,
  height: height,
);
TextStyle txt18BoldRoboto({Color? color,double? height})=>  TextStyle(
  fontSize: 18.SP,
  fontWeight: FontWeight.w700,
  fontFamily: 'Roboto',
  color: color?? Colors.black,
  height: height,
);
TextStyle txt16RegularRoboto({Color? color,double? height})=>  TextStyle(
  fontSize: 16.SP,
  fontWeight: FontWeight.w400,
  fontFamily: 'Roboto',
  color: color?? Colors.black,
  height: height,
);
TextStyle txt14RegularRoboto({Color? color,double? height})=>  TextStyle(
  fontSize: 14.SP,
  fontWeight: FontWeight.w400,
  fontFamily: 'Roboto',
  color: color?? Colors.black,
  height: height,
);
TextStyle txt12RegularRoboto({Color? color,double? height})=>  TextStyle(
  fontSize: 12.SP,
  fontWeight: FontWeight.w400,
  fontFamily: 'Roboto',
  color: color?? Colors.black,
  height: height,
);
TextStyle txt10RegularRoboto({Color? color,double? height})=>  TextStyle(
  fontSize: 10.SP,
  fontWeight: FontWeight.w400,
  fontFamily: 'Roboto',
  color: color?? Colors.black,
  height: height,
);
