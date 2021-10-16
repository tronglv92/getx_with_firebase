import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_extension.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_style.dart';

class AInputForm extends StatefulWidget {
  const AInputForm({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.suffixIcon,
    this.obscureText = false,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator
  }) : super(key: key);

  const AInputForm.email({
    Key? key,
    this.controller,
    this.hintText = 'Email',
    this.labelText,
    this.errorText,
    this.suffixIcon,
    this.obscureText = false,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.emailAddress,
    this.validator
  }) : super(key: key);

  const AInputForm.password({
    Key? key,
    this.controller,
    this.hintText = 'Password',
    this.labelText,
    this.errorText,
    this.suffixIcon,
    this.obscureText = true,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.visiblePassword,
    this.validator
  }) : super(key: key);

  const AInputForm.phone({
    Key? key,
    this.controller,
    this.hintText = 'phone',
    this.labelText,
    this.errorText,
    this.suffixIcon,
    this.obscureText = false,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.phone,
    this.validator
  }) : super(key: key);
  final TextEditingController? controller;
  final String? labelText;
  final String? errorText;
  final String? hintText;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? readOnly;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final bool? enabled;
  final FormFieldValidator<String>? validator;
  @override
  _AInputFormState createState() => _AInputFormState();
}

class _AInputFormState extends State<AInputForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autocorrect: false,
      enabled: widget.enabled,
      enableSuggestions: false,
      style: txt16RegularRoboto(),

      decoration: InputDecoration(
          labelText: widget.labelText,
          errorText: widget.errorText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.grey, width: 0.5.W),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          filled: true,
          hintStyle: TextStyle(
            color: ColorConstants.colorGrayOfText,
          ),
          hintText: widget.hintText,
          fillColor: const Color.fromRGBO(248, 248, 250, 1),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 30.W, vertical: 18.H)),
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      validator: widget.validator,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
    );
  }
}
