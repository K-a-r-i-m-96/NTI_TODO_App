import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/l10n/app_localizations.dart';
import 'package:untitled/core/translation/language_provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: languageProvider,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context)!;
        final isEnglish = languageProvider.currentLocale.languageCode == 'en';

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: const Color(0xFF242424), size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              l10n.settings,
              style: GoogleFonts.lexendDeca(
                color: const Color(0xFF242424),
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.language,
                      style: GoogleFonts.lexendDeca(
                        fontSize: 18.sp,
                        color: const Color(0xFF242424),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Container(
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              languageProvider.changeLanguage('ar');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: !isEnglish ? const Color(0xFF1B9E5A) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                l10n.arabic,
                                style: GoogleFonts.lexendDeca(
                                  color: !isEnglish ? Colors.white : const Color(0xFF6E6E6E),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              languageProvider.changeLanguage('en');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: isEnglish ? const Color(0xFF1B9E5A) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                l10n.english,
                                style: GoogleFonts.lexendDeca(
                                  color: isEnglish ? Colors.white : const Color(0xFF6E6E6E),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
