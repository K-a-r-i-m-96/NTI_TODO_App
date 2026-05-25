import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/features/auth/views/change_password_view.dart';
import 'package:untitled/features/settings/views/settings_view.dart';
import 'package:untitled/features/settings/views/update_profile_view.dart';

import 'package:untitled/l10n/app_localizations.dart';

class ProfileView extends StatefulWidget {
  final String userName;
  const ProfileView({super.key, required this.userName});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late String currentName;

  @override
  void initState() {
    super.initState();
    currentName = widget.userName;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(currentName),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40.r,
                  backgroundImage: const AssetImage(
                    'assets/images/GettyImages-1315607788 2.png',
                  ),
                ),
                SizedBox(width: 16.w),
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
                      currentName,
                      style: GoogleFonts.lexendDeca(
                        color: const Color(0xFF242424),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40.h),
            _buildMenuItem(
              icon: Icons.person_outline,
              title: l10n.profile,
              onTap: () async {
                final newName = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileView(currentName: currentName),
                  ),
                );
                if (newName != null && newName is String) {
                  setState(() {
                    currentName = newName;
                  });
                }
              },
            ),
            SizedBox(height: 16.h),
            _buildMenuItem(
              icon: Icons.lock_outline,
              title: l10n.changePassword,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordView()),
                );
              },
            ),
            SizedBox(height: 16.h),
            _buildMenuItem(
              icon: Icons.settings_outlined,
              title: l10n.settings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 24.sp),
            SizedBox(width: 16.w),
            Text(
              title,
              style: GoogleFonts.lexendDeca(
                fontSize: 16.sp,
                color: const Color(0xFF242424),
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16.sp),
          ],
        ),
      ),
    );
  }
}
