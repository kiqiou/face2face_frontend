import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffix;
  final Widget? prefix;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const MyTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.obscureText,
    required this.keyboardType,
    this.suffix,
    this.prefix,
    this.focusNode,
    this.validator,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      prefix: prefix != null
          ? Padding(
        padding: const EdgeInsets.only(left: 12),
        child: prefix,
      )
          : null,
      suffix: suffix != null
          ? Padding(
        padding: const EdgeInsets.only(right: 12),
        child: suffix,
      )
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      style: const TextStyle(
        fontSize: 18,
        color: CupertinoColors.black,
        fontFamily: 'Manrope',
      ),
      placeholderStyle: const TextStyle(
        color: CupertinoColors.systemGrey,
        fontSize: 16,
        fontFamily: 'Manrope',
      ),
    );
  }
}
