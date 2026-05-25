import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/features/auth/views/register_view.dart';

import 'package:untitled/l10n/app_localizations.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(36.r),
              child: SvgPicture.asset(
                'assets/images/OBJECTS012.svg',
                width: 301.7.w,
                height: 342.86.h,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 114.r),
              child: Text(
                l10n.welcomeToDoIt,
                textAlign: TextAlign.center,
                style: GoogleFonts.lexendDeca(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(30.r),
              child: Text(
                l10n.readyToConquer,
                textAlign: TextAlign.center,
                style: GoogleFonts.lexendDeca(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterView()),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                width: 331.w,
                height: 48.01.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B9E5A),
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1B9E5A).withValues(alpha: 0.4),
                      blurRadius: 15.r,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    l10n.letsStart,
                    style: GoogleFonts.lexendDeca(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
