import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultBtn extends StatelessWidget {
  const DefaultBtn({
    super.key,
    required this.text,
    required this.onTap,
    this.color = const Color(0xFF1B9E5A),
    this.textColor = Colors.white,
    this.height,
    this.width,
  });

  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 60.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
