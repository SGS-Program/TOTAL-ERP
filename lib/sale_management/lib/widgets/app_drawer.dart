import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../Sales_Module/help_support_screen.dart';
import '../Sales_Module/settings_screen.dart';
import '../Proforma_Invoice_Module/all_voice_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 288,
      child: Column(
        children: [
          _DrawerHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              children: [
                const _DrawerSectionLabel('SALES'),
                const _DrawerTile(
                  icon: Icons.dashboard_rounded,
                  label: 'Sales Dashboard',
                  isActive: true,
                ),
                _DrawerTile(
                  icon: Icons.description_outlined,
                  label: 'Proforma Invoice',
                  onTap: () {
                    Navigator.pop(context); // Drawer close
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AllInvoicePage(),
                      ),
                    );
                  },
                ),
                // const _DrawerTile(
                //   icon: Icons.shopping_cart_outlined,
                //   label: 'Sales Order',
                //   badge: '12',
                //   badgeColor: AppColors.primary,
                // ),
                const _DrawerTile(
                  icon: Icons.local_shipping_outlined,
                  label: 'Delivery Challan',
                ),
                const _DrawerTile(
                  icon: Icons.receipt_outlined,
                  label: 'Sales Invoice',
                  badge: '5',
                  badgeColor: AppColors.amber,
                ),
                const _DrawerTile(
                  icon: Icons.approval_outlined,
                  label: 'Invoice Approval',
                ),
                const _DrawerTile(
                  icon: Icons.flash_on_outlined,
                  label: 'Direct Invoice',
                ),
                // const _DrawerDivider(),
                //
                // const _DrawerSectionLabel('RETURNS & COMPLIANCE'),
                // const _DrawerTile(
                //   icon: Icons.assignment_return_outlined,
                //   label: 'Sales Return Invoice',
                //   badge: '3',
                //   badgeColor: AppColors.red,
                // ),
                // const _DrawerTile(
                //   icon: Icons.qr_code_rounded,
                //   label: 'E-Invoice / E-Way Bill',
                // ),
                // const _DrawerTile(
                //   icon: Icons.rule_outlined,
                //   label: 'Sales Return Approval',
                // ),
              ],
            ),
          ),
          _DrawerFooter(),
        ],
      ),
    );
  }
}

// ─── DRAWER HEADER ────────────────────────────────────────────────────────────
class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppDecorations.headerGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                    child: const Icon(
                      Icons.show_chart_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SalesFlow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'ERP SUITE',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.0,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white70, size: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // User card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.2), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'SA',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Super Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            '21472147-DEMO',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E676).withOpacity(0.20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFF00E676).withOpacity(0.35),
                            width: 1),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          color: Color(0xFF69F0AE),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── DRAWER SECTION LABEL ─────────────────────────────────────────────────────
class _DrawerSectionLabel extends StatelessWidget {
  final String label;
  const _DrawerSectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.6,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

// ─── DRAWER DIVIDER ───────────────────────────────────────────────────────────
class _DrawerDivider extends StatelessWidget {
  const _DrawerDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.divider,
      thickness: 1,
      indent: 20,
      endIndent: 20,
      height: 16,
    );
  }
}

// ─── DRAWER TILE ──────────────────────────────────────────────────────────────
class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final String? badge;
  final Color badgeColor;
  final VoidCallback? onTap; // ✅ ADD THIS

  const _DrawerTile({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.badge,
    this.badgeColor = AppColors.primary,
    this.onTap, // ✅ ADD THIS (optional, no required)
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: Material(
        color: isActive
            ? AppColors.primary.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap ?? () => Navigator.pop(context), // ✅ USE onTap
          splashColor: AppColors.primary.withOpacity(0.08),
          highlightColor: AppColors.primary.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                if (isActive)
                  Container(
                    width: 3,
                    height: 18,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                else
                  const SizedBox(width: 11),
                Icon(
                  icon,
                  color: isActive ? AppColors.primary : AppColors.textMuted,
                  size: 19,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive ? AppColors.primary : AppColors.textLight,
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── DRAWER FOOTER ────────────────────────────────────────────────────────────
class _DrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border:
        Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _footerBtn(
              icon: Icons.settings_outlined,
              label: 'Settings',
              color: AppColors.textLight,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
            const Spacer(),
            _footerBtn(
              icon: Icons.help_outline_rounded,
              label: 'Help',
              color: AppColors.textLight,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpSupportPage(),
                  ),
                );
              },
            ),
            const Spacer(),
            _footerBtn(
              icon: Icons.logout_rounded,
              label: 'Logout',
              color: AppColors.red,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}