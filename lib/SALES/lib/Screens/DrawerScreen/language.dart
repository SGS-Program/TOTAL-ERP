import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int _selectedIndex = 0;

  static const _languages = [
    _Language(native: '"हिंदी"',  english: 'Hindi'),
    _Language(native: 'తెలుగు',   english: 'Telugu'),
    _Language(native: 'ಕನ್ನಡ',    english: 'Kannada'),
    _Language(native: 'বাংলা',    english: 'Bengali'),
    _Language(native: 'മലയാളം',   english: 'Malayalam'),
    _Language(native: 'English',  english: 'English'),
    _Language(native: 'ગુજરાતી',  english: 'Gujarati'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: const Color(0xFF26A69A), size: 28.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Choose language',
          style: TextStyle(
            color: const Color(0xFF26A69A),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: _languages.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, i) {
                final lang = _languages[i];
                final selected = _selectedIndex == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF26A69A)
                            : const Color(0xFFDDDDDD),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Radio button
                        Container(
                          width: 20.r,
                          height: 20.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF26A69A)
                                  : const Color(0xFFAAAAAA),
                              width: 1.5,
                            ),
                          ),
                          child: selected
                              ? Center(
                                  child: Container(
                                    width: 10.r,
                                    height: 10.r,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF26A69A),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: 14.w),
                        // Language name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.native,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              lang.english,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Continue button
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Language {
  final String native;
  final String english;
  const _Language({required this.native, required this.english});
}
