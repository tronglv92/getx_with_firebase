import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';
class ASearch extends StatelessWidget {
   const ASearch({Key? key,this.controller,this.suffixIcon,this.onChanged}) : super(key: key);

  final Widget? suffixIcon;
  final TextEditingController? controller;
   final ValueChanged<String>? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
    controller: controller,
      autocorrect: false,
      enableSuggestions: false,
      onChanged: onChanged,
      style: txt16RegularRoboto(),
      decoration: InputDecoration(
          prefixIcon:  Icon(
            Icons.search,
            size: 25.W,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(14),
          )),
    );
  }
}
