import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/features/auth/views/start_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/objects.svg',
              width: 334.w,
              height: 343.94.h,
              colorFilter: null,
            ),
            SizedBox(height: 30.h),
            Text(
              'TODO',
              style: GoogleFonts.lexendDeca(
                fontSize: 36.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1B9E5A),
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
