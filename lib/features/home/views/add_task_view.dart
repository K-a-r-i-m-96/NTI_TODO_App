import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/core/components/default_btn.dart';
import 'package:untitled/core/components/default_text_field.dart';
import 'package:untitled/features/home/cubit/add_task/add_task_cubit.dart';
import 'package:untitled/features/home/cubit/add_task/add_task_state.dart';
import 'package:untitled/l10n/app_localizations.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskCubit(),
      child: BlocConsumer<AddTaskCubit, AddTaskState>(
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          if (state is AddTaskSuccessState) {
            var cubit = AddTaskCubit.get(context);
            Navigator.pop(context, {
              'title': cubit.title.text,
              'description': cubit.description.text,
              'group': cubit.selectedGroup ?? 'Home',
              'date': cubit.dateController.text,
            });
          } else if (state is AddTaskErrorState) {
            var errorMsg = state.error;
            if (errorMsg == 'Please enter a title') {
              errorMsg = l10n.pleaseEnterTitle;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMsg)),
            );
          }
        },
        builder: (context, state) {
          var cubit = AddTaskCubit.get(context);
          final l10n = AppLocalizations.of(context)!;
          
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
                l10n.addTask,
                style: GoogleFonts.lexend(
                  color: const Color(0xFF242424),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Container(
                    height: 220.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/GettyImages-1315607788 2.png'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  DefaultTextField(hintText: l10n.title, controller: cubit.title, isMultiline: true),
                  SizedBox(height: 16.h),
                  DefaultTextField(hintText: l10n.description, controller: cubit.description, isMultiline: true),
                  SizedBox(height: 16.h),
                  _buildDropdownField(context, hint: l10n.group, groups: groups),
                  SizedBox(height: 16.h),
                  DefaultTextField(
                    hintText: l10n.endTime,
                    controller: cubit.dateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    prefixIcon: Icons.calendar_today_outlined,
                  ),
                  SizedBox(height: 40.h),
                  if (state is AddTaskLoadingState)
                    const CircularProgressIndicator(color: Color(0xFF1B9E5A))
                  else
                    DefaultBtn(
                      text: l10n.addTask,
                      onTap: cubit.addTask,
                    ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final cubit = AddTaskCubit.get(context);
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
        initialTime: TimeOfDay.now(),
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
    final cubit = AddTaskCubit.get(context);
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
