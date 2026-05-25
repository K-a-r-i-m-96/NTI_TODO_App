import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/core/components/default_btn.dart';
import 'package:untitled/core/components/default_text_field.dart';
import 'package:untitled/features/home/cubit/delete_task/delete_task_cubit.dart';
import 'package:untitled/features/home/cubit/delete_task/delete_task_state.dart';
import 'package:untitled/features/home/cubit/update_task/update_task_cubit.dart';
import 'package:untitled/features/home/cubit/update_task/update_task_state.dart';
import 'package:untitled/features/home/data/models/task_model.dart';
import 'package:untitled/l10n/app_localizations.dart';

class EditTaskView extends StatelessWidget {
  final Map<String, String> task;
  final int index;

  const EditTaskView({super.key, required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final taskModel = TaskModel.fromJson(task);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UpdateTaskCubit(taskModel)),
        BlocProvider(create: (context) => DeleteTaskCubit(taskModel)),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<UpdateTaskCubit, UpdateTaskState>(
            listener: (context, state) {
              if (state is UpdateTaskSuccessState) {
                var cubit = UpdateTaskCubit.get(context);
                Navigator.pop(context, {
                  'action': 'update',
                  'index': index,
                  'task': cubit.taskModel.toJson(),
                });
              }
            },
          ),
          BlocListener<DeleteTaskCubit, DeleteTaskState>(
            listener: (context, state) {
              if (state is DeleteTaskSuccessState) {
                Navigator.pop(context, {'action': 'delete', 'index': index});
              }
            },
          ),
        ],
        child: BlocBuilder<UpdateTaskCubit, UpdateTaskState>(
          builder: (context, state) {
            var updateCubit = UpdateTaskCubit.get(context);
            var deleteCubit = DeleteTaskCubit.get(context);

            final List<Map<String, String>> groups = [
              {'name': 'Home', 'icon': 'assets/images/Home.png'},
              {'name': 'Personal', 'icon': 'assets/images/personal.png'},
              {'name': 'Work', 'icon': 'assets/images/work.png'},
            ];

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  l10n.editTask,
                  style: GoogleFonts.lexend(
                    color: const Color(0xFF242424),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: GestureDetector(
                      onTap: deleteCubit.deleteTask,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE94040),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.white, size: 18.sp),
                            SizedBox(width: 4.w),
                            Text(
                              l10n.delete,
                              style: GoogleFonts.lexend(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 45.r,
                          backgroundImage: const AssetImage('assets/images/GettyImages-1315607788 2.png'),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                updateCubit.isDone ? l10n.completed : l10n.inProgress,
                                style: GoogleFonts.lexend(
                                  color: const Color(0xFF6E6E6E),
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                l10n.quote,
                                style: GoogleFonts.lexend(
                                  color: const Color(0xFF242424),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    _buildDropdownField(context, hint: l10n.group, groups: groups),
                    SizedBox(height: 16.h),
                    DefaultTextField(hintText: l10n.title, controller: updateCubit.title),
                    SizedBox(height: 16.h),
                    DefaultTextField(hintText: l10n.description, controller: updateCubit.description, isMultiline: true),
                    SizedBox(height: 16.h),
                    DefaultTextField(
                      hintText: l10n.endTime,
                      controller: updateCubit.dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      prefixIcon: Icons.calendar_today_outlined,
                    ),
                    SizedBox(height: 100.h),
                    DefaultBtn(
                      text: l10n.markAsDone,
                      onTap: updateCubit.markAsDone,
                    ),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: updateCubit.updateTask,
                      child: Container(
                        width: double.infinity,
                        height: 55.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(color: const Color(0xFF1B9E5A), width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            l10n.update,
                            style: GoogleFonts.lexend(
                              color: const Color(0xFF1B9E5A),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final cubit = UpdateTaskCubit.get(context);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: cubit.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1B9E5A),
              primary: const Color(0xFF1B9E5A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
              brightness: Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: cubit.selectedDate != null
            ? TimeOfDay.fromDateTime(cubit.selectedDate!)
            : TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1B9E5A),
                primary: const Color(0xFF1B9E5A),
                onPrimary: Colors.white,
                onSurface: Colors.black,
                brightness: Brightness.light,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        cubit.onDateChanged(pickedDate, pickedTime);
      }
    }
  }

  Widget _buildDropdownField(BuildContext context, {required String hint, required List<Map<String, String>> groups}) {
    final cubit = UpdateTaskCubit.get(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        initialValue: cubit.selectedGroup,
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.lexend(
            color: const Color(0xFFA9A9A9),
            fontSize: 15.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.r),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.r),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.r),
            borderSide: const BorderSide(color: Color(0xFF1B9E5A), width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        ),
        items: groups.map((group) {
          return DropdownMenuItem<String>(
            value: group['name'],
            child: Row(
              children: [
                Image.asset(
                  group['icon']!,
                  width: 24.w,
                  height: 24.h,
                ),
                SizedBox(width: 12.w),
                Text(
                  group['name']!,
                  style: GoogleFonts.lexend(
                    color: const Color(0xFF242424),
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: cubit.onGroupChanged,
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 24.sp),
        borderRadius: BorderRadius.circular(18.r),
      ),
    );
  }
}
