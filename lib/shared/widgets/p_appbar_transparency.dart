import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'p_material.dart';


class PAppBarTransparency extends StatelessWidget {
  const PAppBarTransparency(
      {this.body,
      this.child,
      this.forceStatusIconLight,
      this.bottomNavigationBar,
        this.backgroundColor,
        this.bottomSheet,
      Key? key})
      : super(key: key);

  final Widget? child;
  final Widget? body;
  final bool? forceStatusIconLight;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final Widget? bottomSheet;
  @override
  Widget build(BuildContext context) {

    final SystemUiOverlayStyle uiOverlayStyle = forceStatusIconLight == null
        ? (Get.isDarkMode
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light)
        : forceStatusIconLight == true
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;


    return PMaterial(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: uiOverlayStyle.copyWith(statusBarColor: Colors.transparent),
        child: body ??
            Scaffold(
                backgroundColor:context.theme.backgroundColor,
                body: child,
                bottomNavigationBar: bottomNavigationBar,
            bottomSheet: bottomSheet,
            ),
      ),
    );
  }
}
