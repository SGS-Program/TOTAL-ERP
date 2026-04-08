import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'TOTAL_ERP/splash/splash_screen.dart';
import 'package:crm/providers/theme_provider.dart';
import 'firebase_options.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'l10n/app_localizations.dart';
import 'package:hrm/services/device_service.dart';

// Top-level ValueNotifier available throughout the application
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize device ID and location for all modules
  try {
    await DeviceService.initDeviceInfo();
  } catch (e) {
    debugPrint("Global Device Init Error: $e");
  }
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialise ScreenUtil once for the whole app.
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, ThemeMode currentMode, __) {
            return ValueListenableBuilder<Locale>(
              valueListenable: localeNotifier,
              builder: (_, Locale currentLocale, __) {
                return MaterialApp(
                  title: 'ERP',
                  debugShowCheckedModeBanner: false,
                  themeMode: currentMode,
                  locale: currentLocale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en'), // English
                    Locale('ta'), // Tamil
                    Locale('hi'), // Hindi
                  ],
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: const Color(0xFF26A69A),
                    ),
                    useMaterial3: true,
                    textTheme: GoogleFonts.outfitTextTheme().copyWith(
                      titleLarge: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                      bodyMedium: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    appBarTheme: AppBarTheme(
                      backgroundColor: const Color(0xFF26A69A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      centerTitle: false,
                      titleTextStyle: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      iconTheme: const IconThemeData(color: Colors.white),
                    ),
                    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                      backgroundColor: Color(0xFF26A69A),
                      selectedItemColor: Colors.white,
                      unselectedItemColor: Colors.white60,
                      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                      type: BottomNavigationBarType.fixed,
                      elevation: 10,
                    ),
                  ),
                  darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: const Color(0xFF26A69A),
                      brightness: Brightness.dark,
                    ),
                    textTheme: GoogleFonts.outfitTextTheme().copyWith(
                      titleLarge: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: Colors.white,
                      ),
                      bodyMedium: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    appBarTheme: AppBarTheme(
                      backgroundColor: const Color(0xFF26A69A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      centerTitle: false,
                      titleTextStyle: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      iconTheme: const IconThemeData(color: Colors.white),
                    ),
                    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                      backgroundColor: Color(0xFF26A69A),
                      selectedItemColor: Colors.white,
                      unselectedItemColor: Colors.white60,
                      type: BottomNavigationBarType.fixed,
                    ),
                  ),
                  home: const SplashScreen(),
                );
              },
            );
          },
        );
      },
    );
  }
}
