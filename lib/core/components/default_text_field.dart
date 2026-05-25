import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultTextField extends StatelessWidget {
  const DefaultTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.svgPrefixIcon,
    this.svgPasswordVisibleIcon,
    this.svgPasswordHiddenIcon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onPasswordToggle,
    this.validator,
    this.isMultiline = false,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final String? svgPrefixIcon;
  final String? svgPasswordVisibleIcon;
  final String? svgPasswordHiddenIcon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onPasswordToggle;
  final String? Function(String?)? validator;
  final bool isMultiline;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !isPasswordVisible : false,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: isMultiline ? null : 1,
      keyboardType: isMultiline ? TextInputType.multiline : TextInputType.text,
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16.sp),
        prefixIcon: svgPrefixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SvgPicture.asset(
                  svgPrefixIcon!,
                  width: 28.w,
                  height: 28.h,
                  fit: BoxFit.scaleDown,
                ),
              )
            : prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Icon(prefixIcon, color: Colors.black, size: 28.sp),
                  )
                : null,
        suffixIcon: isPassword
            ? IconButton(
                icon: isPasswordVisible
                    ? (svgPasswordVisibleIcon != null
                        ? SvgPicture.asset(
                            svgPasswordVisibleIcon!,
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.scaleDown,
                            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                          )
                        : Icon(Icons.visibility, color: Colors.grey, size: 24.sp))
                    : (svgPasswordHiddenIcon != null
                        ? SvgPicture.asset(
                            svgPasswordHiddenIcon!,
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.scaleDown,
                            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                          )
                        : Icon(Icons.visibility_off, color: Colors.grey, size: 24.sp)),
                onPressed: onPasswordToggle,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: const BorderSide(color: Color(0xFF1B9E5A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
