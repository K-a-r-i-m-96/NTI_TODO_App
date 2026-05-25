import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTasksView extends StatelessWidget {
  const HomeTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 35.r,
                    backgroundImage: const AssetImage(
                      'assets/images/GettyImages-1315607788 2.png',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello!',
                        style: GoogleFonts.lexendDeca(
                          color: const Color(0xFF6E6E6E),
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        'Ahmed Saber',
                        style: GoogleFonts.lexendDeca(
                          color: const Color(0xFF242424),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                    },
                    icon: SvgPicture.asset(
                      'assets/images/Plus - Iconly Pro.svg',
                      width: 28.w,
                      height: 28.h,
                    ),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              Row(
                children: [
                  SizedBox(
                    width: 101.w,
                    height: 18.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Text(
                          'Tasks',
                          style: GoogleFonts.lexendDeca(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF242424),
                            height: 1.0,
                          ),
                        ),
                        Positioned(
                          left: 70.w,
                          top: 1.5.h,
                          child: Container(
                            width: 14.w,
                            height: 15.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD2ECE0),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Text(
                              '5',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendDeca(
                                color: const Color(0xFF1B9E5A),
                                fontWeight: FontWeight.bold,
                                fontSize: 9.sp,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              Expanded(
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return const TaskItemCard(
                      title: 'My First Task',
                      description: 'Improve my English skills by trying to speek',
                      date: '11/03/2025',
                      time: '05:00 PM',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskItemCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String time;

  const TaskItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335.w,
      height: 90.h,
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFCEEBDC),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lexendDeca(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6E6E6E),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '$date\n$time',
                textAlign: TextAlign.right,
                style: GoogleFonts.lexendDeca(
                  fontSize: 12.sp,
                  color: const Color(0xFF6E6E6E),
                  height: 1.1,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lexendDeca(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF242424),
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
