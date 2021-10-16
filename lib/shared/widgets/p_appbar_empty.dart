import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'p_material.dart';


class PAppBarEmpty extends StatelessWidget {
  const PAppBarEmpty({required this.child, this.actionBtn,this.bottomNavigationBar, Key? key}) : super(key: key);

  final Widget child;
  final Widget? actionBtn;
  final Widget? bottomNavigationBar;
  @override
  Widget build(BuildContext context) {

    return PMaterial(
      child: Scaffold(
        backgroundColor: context.theme.backgroundColor ,
        appBar: PreferredSize(
          preferredSize: const Size(0, 0),
          child: AppBar(
            elevation: 0,
            brightness: context.theme.brightness,
            backgroundColor: context.theme.appBarTheme.backgroundColor,
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: child,
        ),
        bottomNavigationBar:bottomNavigationBar ,
        floatingActionButton: actionBtn,
      ),
    );
  }
}
