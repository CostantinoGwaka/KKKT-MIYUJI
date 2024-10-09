import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  ///each text field should have it's own controller
  final TextEditingController? controller;

  // on changed function
  final ValueChanged<String>? onchanged;

  final TextStyle? textStyle;

  ///shown after initialize the widget
  final String? label;

  ///maximum lines a field takes
  final int maxLines;

  final int? maxLength;
  final int? minLines;

  final TextInputAction inputAction;

  final IconData? prefixIcon;

  ///used mostly in password fields
  final bool obscure;

  final Widget? suffixIcon;
  final String? helperText;
  final String? hint;
  final Color? errorColor;
  final Color? cursorColor;
  final Color? focusColor;
  final Color? hintColor;
  final bool? filled;
  final Color? fillColor;
  final Color? labelColor;
  final FloatingLabelBehavior? float;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? padding;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatter;
  final double? labelSize;
  final Color? helperColor;
  final double? helperSize;
  final bool allowPre;
  final Widget? prefix;

  ///initialized in the user focus area
  final String? pre;

  ///inputs for all texts committed
  InputField(
      {super.key,
      this.labelColor,
      this.allowPre = false,
      this.minLines,
      this.textStyle,
      this.prefix,
      this.validator,
      this.hint,
      this.onchanged,
      this.padding,
      this.controller,
      this.fillColor,
      this.labelSize,
      this.keyboardType = TextInputType.text,
      this.focusColor,
      this.filled = true,
      this.hintColor,
      this.float = FloatingLabelBehavior.auto,
      this.cursorColor,
      this.helperColor,
      this.pre,
      this.helperText,
      this.errorColor = Colors.redAccent,
      this.obscure = false,
      @required this.label,
      this.maxLines = 1,
      this.maxLength,
      this.suffixIcon,
      this.prefixIcon,
      this.inputAction = TextInputAction.done,
      this.inputFormatter,
      this.helperSize});

  final outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey[300]!),
    borderRadius: BorderRadius.circular(5),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        style: textStyle,
        validator: validator,
        obscureText: obscure,
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        textInputAction: inputAction,
        enableInteractiveSelection: true,
        keyboardType: keyboardType,
        onChanged: onchanged,
        minLines: minLines,
        inputFormatters: inputFormatter,
        // style:
        smartQuotesType: SmartQuotesType.enabled,
        decoration: InputDecoration(
            hintStyle: TextStyle(color: hintColor),
            contentPadding: padding,
            hintText: hint,
            floatingLabelBehavior: float,
            filled: filled,
            prefix: Text(
              pre ?? ' ',
              style: TextStyle(fontSize: labelSize),
              textScaleFactor: 1,
            ),
            helperText: helperText,
            helperStyle: TextStyle(color: helperColor, fontSize: helperSize),
            errorStyle: TextStyle(color: errorColor),
            focusedErrorBorder: outlineInputBorder,
            errorBorder: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            border: outlineInputBorder,
            prefixIcon: allowPre
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: prefix,
                  )
                : Icon(
                    prefixIcon,
                  ),
            suffixIcon: suffixIcon,
            labelText: label ?? ' ',
            labelStyle: TextStyle(fontSize: labelSize, color: labelColor)),
      ),
    );
  }
}
