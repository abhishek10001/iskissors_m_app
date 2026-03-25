import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isUnderline;

  const CustomTextField({
    super.key,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.validator,
    this.isUnderline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isUnderline) {
      return TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textLight),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(prefixIcon, color: AppColors.textGrey, size: 22),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 34,
            minHeight: 22,
          ),
          prefix: prefix,
          suffixIcon: suffixIcon,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 16,
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.divider),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      );
    }

    // Default rounded pill style
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.caption.copyWith(color: AppColors.textLight),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 12),
                child: Icon(prefixIcon, color: AppColors.primary, size: 22),
              )
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
