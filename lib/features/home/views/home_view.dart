import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/core/cache/cache_helper.dart';
import 'package:untitled/features/home/cubit/get_tasks/get_tasks_cubit.dart';
import 'package:untitled/features/home/cubit/get_tasks/get_tasks_state.dart';
import 'package:untitled/features/home/views/add_task_view.dart';
import 'package:untitled/features/home/views/edit_task_view.dart';
import 'package:untitled/features/settings/views/profile_view.dart';
import 'package:untitled/l10n/app_localizations.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String userName;

  @override
  void initState() {
    super.initState();
    userName = CacheHelper.getValue('userName') as String? ?? 'Ahmed Saber';
  }

  List<String> _parseDateAndTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return ['', ''];
    }
    if (dateStr.contains(RegExp(r'\s{2,}'))) {
      final parts = dateStr.split(RegExp(r'\s{2,}'));
      return [parts.first.trim(), parts.last.trim()];
    }
    if (dateStr.contains('\n')) {
      final parts = dateStr.split('\n');
      return [parts.first.trim(), parts.last.trim()];
    }
    final parts = dateStr.trim().split(RegExp(r'\s+'));
    if (parts.length >= 3) {
      final datePart = parts[0];
      final timePart = '${parts[1]} ${parts[2]}';
      return [datePart, timePart];
    }
    return [dateStr, ''];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => GetTasksCubit()..getTasks(),
      child: BlocBuilder<GetTasksCubit, GetTasksState>(
        builder: (context, state) {
          var cubit = GetTasksCubit.get(context);
          var tasks = cubit.tasks;

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
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileView(userName: userName),
                              ),
                            );
                            if (result != null && result is String) {
                              setState(() {
                                userName = result;
                              });
                            } else {
                              setState(() {
                                userName = CacheHelper.getValue('userName') as String? ?? userName;
                              });
                            }
                          },
                          child: CircleAvatar(
                            radius: 35.r,
                            backgroundImage: const AssetImage(
                              'assets/images/GettyImages-1315607788 2.png',
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.hello,
                              style: GoogleFonts.lexendDeca(
                                color: const Color(0xFF6E6E6E),
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              userName,
                              style: GoogleFonts.lexendDeca(
                                color: const Color(0xFF242424),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        if (tasks.isNotEmpty)
                          IconButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddTaskView()),
                              );

                              if (result != null) {
                                cubit.getTasks();
                              }
                            },
                            icon: SvgPicture.asset(
                              'assets/images/Plus - Iconly Pro.svg',
                              width: 28.w,
                              height: 28.h,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF1B9E5A),
                                BlendMode.srcIn,
                              ),
                            ),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    if (state is GetTasksLoadingState)
                      const Expanded(child: Center(child: CircularProgressIndicator(color: Color(0xFF1B9E5A))))
                    else if (tasks.isEmpty) ...[
                      const Spacer(flex: 2),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.noTasksYet,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendDeca(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF242424),
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 40.h),
                            SvgPicture.asset(
                              'assets/images/55024598_9264826 1.svg',
                              width: 280.w,
                              colorFilter: null,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 3),
                    ] else ...[
                      Row(
                        children: [
                          SizedBox(
                            width: 101.w,
                            height: 18.h,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Text(
                                  l10n.tasks,
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
                                      '${tasks.length}',
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
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            bool isCompleted = task.isDone == 'true';
                            return GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditTaskView(
                                      task: task.toJson().map((k, v) => MapEntry(k, v?.toString() ?? '')),
                                      index: index,
                                    ),
                                  ),
                                );
                                if (result != null) cubit.getTasks();
                              },
                              child: () {
                                final dateTimeParts = _parseDateAndTime(task.date);
                                final displayDate = dateTimeParts[0];
                                final displayTime = dateTimeParts[1];

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
                                              (task.title == null || task.title!.trim().isEmpty)
                                                  ? l10n.untitledTask
                                                  : task.title!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.lexendDeca(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: (task.title == null || task.title!.trim().isEmpty)
                                                    ? const Color(0xFF9E9E9E)
                                                    : const Color(0xFF6E6E6E),
                                                decoration: isCompleted ? TextDecoration.lineThrough : null,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (displayDate.isNotEmpty)
                                                Text(
                                                  displayDate,
                                                  textAlign: TextAlign.right,
                                                  style: GoogleFonts.lexendDeca(
                                                    fontSize: 12.sp,
                                                    color: const Color(0xFF6E6E6E),
                                                    height: 1.1,
                                                  ),
                                                ),
                                              if (displayTime.isNotEmpty)
                                                Text(
                                                  displayTime,
                                                  textAlign: TextAlign.right,
                                                  style: GoogleFonts.lexendDeca(
                                                    fontSize: 12.sp,
                                                    color: const Color(0xFF6E6E6E),
                                                    height: 1.1,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                      Expanded(
                                        child: Text(
                                          (task.description == null || task.description!.trim().isEmpty)
                                              ? l10n.noDescription
                                              : task.description!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lexendDeca(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                            color: (task.description == null || task.description!.trim().isEmpty)
                                                ? const Color(0xFF9E9E9E)
                                                : const Color(0xFF242424),
                                            height: 1.1,
                                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }(),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            floatingActionButton: tasks.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(right: 10.w, bottom: 20.h),
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddTaskView()),
                        );

                        if (result != null) {
                          cubit.getTasks();
                        }
                      },
                      child: Image.asset(
                        'assets/images/Group 1000002835.png',
                        width: 70.w,
                        height: 70.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
