import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crm/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart'; // Import themeNotifier
import 'security_pin_screen.dart'; // Import Security PIN screen
import '../../utils/localization.dart';
import '../login/sign_in_screen.dart';

class SettingsSubScreen extends StatefulWidget {
  const SettingsSubScreen({super.key});

  @override
  State<SettingsSubScreen> createState() => _SettingsSubScreenState();
}

class _SettingsSubScreenState extends State<SettingsSubScreen> {
  bool _pushNotifications = true;
  bool _pinEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkPinState();
  }

  Future<void> _checkPinState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pinEnabled = prefs.getString('app_pin') != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Profile Card
          _buildProfileCard(),
          const SizedBox(height: 24),
          // Account Section
          _buildSectionTitle('ACCOUNT'),
          const SizedBox(height: 12),
          _buildGroupedCard([
            _buildListTile(
              icon: Icons.person_outline_rounded,
              iconColor: Colors.deepPurple,
              iconBgColor: const Color(0xFFEDE7F6),
              title: AppLocalization.of('Personal Information'),
              onTap: () {},
            ),
            _buildDivider(),
            _buildSwitchTile(
              icon: Icons.lock_outline_rounded,
              iconColor: Colors.green,
              iconBgColor: const Color(0xFFE8F5E9),
              title: AppLocalization.of('App Lock PIN'),
              value: _pinEnabled,
              onChanged: (val) async {
                if (val) {
                  // Enable
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecurityPinScreen(isSetup: true),
                    ),
                  );
                  if (result == true) setState(() => _pinEnabled = true);
                } else {
                  // Disable
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecurityPinScreen(isTurningOff: true),
                    ),
                  );
                  // Returns false if disabled successfully logic handles pop backwards
                  if (result == false) setState(() => _pinEnabled = false);
                }
              },
            ),
            _buildDivider(),
            _buildListTile(
              icon: Icons.credit_card_rounded,
              iconColor: Colors.orange,
              iconBgColor: const Color(0xFFFFF3E0),
              title: 'Billing & Details',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 24),
          // Preferences Section
          _buildSectionTitle('PREFERENCES'),
          const SizedBox(height: 12),
          _buildGroupedCard([
            _buildSwitchTile(
              icon: Icons.notifications_none_rounded,
              iconColor: Colors.pink,
              iconBgColor: const Color(0xFFFCE4EC),
              title: AppLocalization.of('Push Notifications'),
              value: _pushNotifications,
              onChanged: (val) => setState(() => _pushNotifications = val),
            ),
            _buildDivider(),
            _buildSwitchTile(
              icon: Icons.dark_mode_outlined,
              iconColor: Colors.black87,
              iconBgColor: const Color(0xFFECEFF1),
              title: AppLocalization.of('Dark Mode'),
              value: themeNotifier.value == ThemeMode.dark,
              onChanged: (val) {
                setState(() {
                  themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                  // Sync with CRM ThemeProvider
                  try {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(val);
                  } catch (e) {
                    // CRM Provider might not be initialized yet or not found in tree
                    debugPrint('CRM ThemeProvider sync error: $e');
                  }
                });
              },
            ),
            _buildDivider(),
            _buildListTile(
              icon: Icons.language_rounded,
              iconColor: Colors.redAccent,
              iconBgColor: const Color(0xFFFFEBEE),
              title: AppLocalization.of('Language'),
              trailingText: _getLangName(localeNotifier.value.languageCode),
              onTap: _showLanguagePicker,
            ),
          ]),
          const SizedBox(height: 24),
          // Support Section
          _buildSectionTitle('SUPPORT'),
          const SizedBox(height: 12),
          _buildGroupedCard([
            _buildListTile(
              icon: Icons.help_outline_rounded,
              iconColor: Colors.blue,
              iconBgColor: const Color(0xFFE3F2FD),
              title: AppLocalization.of('Help Center'),
              onTap: () {},
            ),
            _buildDivider(),
            _buildListTile(
              icon: Icons.info_outline_rounded,
              iconColor: Colors.lightGreen,
              iconBgColor: const Color(0xFFF1F8E9),
              title: AppLocalization.of('Terms & Policies'),
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 32),
          // Log Out Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('is_logged_in', false);
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFFFEBEE),
                side: const BorderSide(color: Colors.redAccent, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                AppLocalization.of('Log Out'),
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 100), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey, size: 28),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin User',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Admin@smart-erp.com',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Edit Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.indigo.shade900 : Colors.indigo.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit, color: Theme.of(context).brightness == Brightness.dark ? Colors.indigo.shade200 : Colors.indigo, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Colors.grey,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildGroupedCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 64,
      color: Color(0xFFF5F5F5),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey, 
                fontSize: 13, 
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(width: 4),
          Icon(Icons.arrow_forward_ios_rounded, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade500 : Colors.grey, size: 16),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: Colors.deepPurpleAccent,
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade300 : Colors.white,
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade600 : Colors.grey.shade300,
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Language', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Divider(),
              _buildLangItem('English', 'en'),
              _buildLangItem('Tamil (தமிழ்)', 'ta'),
              _buildLangItem('Hindi (हिन्दी)', 'hi'),
              _buildLangItem('Telugu (తెలుగు)', 'te'),
              _buildLangItem('Kannada (ಕನ್ನಡ)', 'kn'),
              _buildLangItem('Malayalam (മലയാളം)', 'ml'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLangItem(String name, String code) {
    return ListTile(
      title: Text(name),
      trailing: localeNotifier.value.languageCode == code ? const Icon(Icons.check, color: Colors.deepPurpleAccent) : null,
      onTap: () {
        localeNotifier.value = Locale(code);
        Navigator.pop(context);
        setState(() {}); // refresh screen
      },
    );
  }

  String _getLangName(String code) {
    switch (code) {
      case 'ta': return 'Tamil';
      case 'hi': return 'Hindi';
      case 'te': return 'Telugu';
      case 'kn': return 'Kannada';
      case 'ml': return 'Malayalam';
      default: return 'English';
    }
  }
}
