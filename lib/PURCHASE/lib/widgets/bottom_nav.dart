import 'package:flutter/material.dart';
import 'package:purchase_erp/Request%20Approvals/approvals.dart';
import 'package:purchase_erp/purchase_orders/purchase_orders.dart';
import 'package:purchase_erp/purchase_request.dart';

import '../dashboard.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavBar({super.key, this.selectedIndex = 0});

  void onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;

    Widget targetScreen;
    switch (index) {
      case 1:
        targetScreen = const PurchaseRequestScreen();
        break;
      case 2:
        targetScreen = const RequestApprovals();
        break;
      case 3:
        targetScreen = const PurchaseOrdersScreen();
        break;
      case 0:
      default:
        targetScreen = const Dashboard();
        break;
    }

    // Use pushReplacement to avoid building huge back stacks and overlap
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => targetScreen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12, width: 1.0)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: navItem(context, Icons.dashboard, "Dashboard", 0)),
            Expanded(child: navItem(context, Icons.assignment_add, "PR", 1)),
            Expanded(
              child: navItem(
                context,
                Icons.published_with_changes,
                "Approvals",
                2,
              ),
            ),
            Expanded(child: navItem(context, Icons.shopping_cart, "PO", 3)),
          ],
        ),
      ),
    );
  }

  Widget navItem(BuildContext context, IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? const Color(0xFF26A69A) : Colors.grey;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onItemTapped(context, index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
