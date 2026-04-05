import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dashboard_sub_screen.dart';
import 'notifications_sub_screen.dart';
import 'settings_sub_screen.dart';
import '../../utils/localization.dart';
import '../../utils/constants/module_constants.dart';
import '../../utils/widgets/universal_app_bar.dart';
import '../../utils/widgets/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Widget? _activeModule; // Persistent Module State
  String? _activeModuleTitle;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onModuleSelected(Widget moduleScreen, String moduleTitle) {
    setState(() {
      _activeModule = moduleScreen;
      _activeModuleTitle = moduleTitle;
    });
  }

  void _clearActiveModule() {
    setState(() {
      _activeModule = null;
      _activeModuleTitle = null;
    });
  }

  late final List<Widget> _baseScreens;

  @override
  void initState() {
    super.initState();
    _baseScreens = [
      AppGridSubScreen(onModuleSelected: _onModuleSelected),
      const DashboardSubScreen(),
      const NotificationsSubScreen(),
      const SettingsSubScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF26A69A);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: _activeModule == null,
      onPopInvoked: (didPop) {
        if (!didPop && _activeModule != null) {
          _clearActiveModule();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: tealColor,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: false,
          drawer: const MainDrawer(),
          appBar: UniversalAppBar(
            title: _activeModule != null
                ? AppLocalization.of(_activeModuleTitle ?? "")
                : (_selectedIndex == 0
                    ? AppLocalization.of('Smart ERP')
                    : (_selectedIndex == 1
                        ? AppLocalization.of('ERP Dashboard')
                        : (_selectedIndex == 2
                            ? AppLocalization.of('Notification')
                            : AppLocalization.of('Settings')))),
            subtitle: _activeModule != null
                ? AppLocalization.of('Workplace Dashboard')
                : (_selectedIndex == 0
                    ? AppLocalization.of('Workplace Dashboard')
                    : (_selectedIndex == 1
                        ? AppLocalization.of('Analytics & Reports')
                        : (_selectedIndex == 2
                            ? AppLocalization.of('You have 3 unread messages')
                            : AppLocalization.of('Manage preferences and configuration')))),
            showBackButton: _activeModule != null,
            onBackTap: _activeModule != null ? _clearActiveModule : null,
            isDark: isDark,
          ),
          body: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: _selectedIndex == 0 && _activeModule != null
                      ? _activeModule!
                      : IndexedStack(
                          key: ValueKey<int>(_selectedIndex),
                          index: _selectedIndex,
                          children: _baseScreens,
                        ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _activeModule != null ? null : SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 15.h),
              child: Container(
                height: 72.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(Icons.grid_view_rounded, 0, tealColor),
                    _buildNavItem(Icons.dashboard_customize_outlined, 1, tealColor),
                    _buildNavItem(Icons.notifications_none_rounded, 2, tealColor),
                    _buildNavItem(Icons.settings_outlined, 3, tealColor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, Color tealColor) {
    bool isActive = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          if (index != 0) _activeModule = null; // Reset module if switching tabs
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60.w,
        child: Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: isActive ? 1.2 : 1.0,
            curve: Curves.easeOutCubic,
            child: Icon(
              icon,
              color: isActive ? tealColor : Colors.grey.shade400,
              size: 26.w,
            ),
          ),
        ),
      ),
    );
  }
}

class AppGridSubScreen extends StatelessWidget {
  final Function(Widget, String) onModuleSelected;
  const AppGridSubScreen({super.key, required this.onModuleSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalization.of('Select an App to Manage'),
              style: GoogleFonts.outfit(
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: GridView.count(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 100.h),
            crossAxisCount: 4,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: 0.72,
            children: [
              ...allModules.map((module) {
                return _buildAppCard(
                  context,
                  module.title,
                  module.imagePath,
                  module.bgColor,
                  module.fallbackIcon,
                  () {
                    if (module.screenBuilder != null) {
                      // Instead of Navigator.push, we call the persistency callback
                      onModuleSelected(module.screenBuilder!(context), module.title);
                    }
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppCard(
    BuildContext context,
    String label,
    String imagePath,
    Color bgColor,
    IconData fallbackIcon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              double size = constraints.maxWidth;
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(size * 0.18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(imagePath.isNotEmpty ? 8.w : 12.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size * 0.12),
                  child: imagePath.isNotEmpty
                      ? Image.asset(imagePath, fit: BoxFit.contain)
                      : Icon(
                          fallbackIcon,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.blueGrey.shade800,
                          size: size * 0.4,
                        ),
                ),
              );
            },
          ),
          SizedBox(height: 8.h),
          Text(
            AppLocalization.of(label),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              height: 1.1,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9), delay: 100.ms);
  }
}
