import 'package:flutter/material.dart';
import '../models/module_model.dart';

import 'package:crm_admin_app/Screens/dashboard_screen.dart' as crm_admin;
import 'package:purchase_erp/dashboard.dart' as purchase;
import 'package:hrm_admin_app/Screens/Admin/admin_dashboard.dart' as hrm_admin;
import 'package:sale_management/Sales_Module/sale_dashboard.dart' as sale_mgmt;
import 'package:ecommerce/ecommerce.dart' as ecommerce;
import 'package:accounting_erp/accounting_root.dart' as accounting;
import 'package:hrm/views/main_root.dart' as hrm;
import 'package:warehouse/warehouse.dart' as warehouse;

/// Globally accessible key to control modular scaffolds (e.g., opening drawers from host app bar)
final GlobalKey<ScaffoldState> moduleScaffoldKey = GlobalKey<ScaffoldState>();

final List<ModuleItem> allModules = [
  ModuleItem(
    title: 'HRM',
    imagePath: 'assets/images/hrm.png',
    bgColor: Color(0xFFE3F2FD),
    fallbackIcon: Icons.people_alt,
    screenBuilder: (context) => const hrm.MainRoot(isEmbedded: true),
  ),
  ModuleItem(
    title: 'CRM Admin',
    imagePath: 'assets/images/crm.png',
    bgColor: Color(0xFFE8F5E9),
    fallbackIcon: Icons.handshake,
    screenBuilder: (context) => crm_admin.DashboardScreen(isEmbedded: true, scaffoldKey: moduleScaffoldKey),
  ),
  ModuleItem(
    title: 'Inventory',
    imagePath: 'assets/images/inventory.png',
    bgColor: Color(0xFFFFF3E0),
    fallbackIcon: Icons.inventory_2,
  ),
  ModuleItem(
    title: 'Accounting',
    imagePath: 'assets/images/financials.png',
    bgColor: Color(0xFFF3E5F5),
    fallbackIcon: Icons.account_balance_wallet,
    screenBuilder: (context) => accounting.AccountingRoot(isEmbedded: true, scaffoldKey: moduleScaffoldKey),
  ),
  ModuleItem(
    title: 'Sales',
    imagePath: 'assets/images/sales.png',
    bgColor: Color(0xFFFFEBEE),
    fallbackIcon: Icons.local_offer,
    screenBuilder: (context) => sale_mgmt.DashboardPage(isEmbedded: true, scaffoldKey: moduleScaffoldKey),
  ),
  ModuleItem(
    title: 'Ecommerce',
    imagePath: 'assets/images/ecommerce.png',
    bgColor: Color(0xFFE0F2F1),
    fallbackIcon: Icons.shopping_cart,
    screenBuilder: (context) => const ecommerce.EcommerceDashboard(isEmbedded: true),
  ),
  ModuleItem(
    title: 'Warehouse',
    imagePath: 'assets/images/warehouse.png',
    bgColor: Color(0xFFE0F7FA),
    fallbackIcon: Icons.warehouse,
    screenBuilder: (context) => warehouse.WarehouseDashboard(isEmbedded: true, scaffoldKey: moduleScaffoldKey),
  ),
  ModuleItem(
    title: 'Manufacturing',
    imagePath: 'assets/images/manufacturing.png',
    bgColor: Color(0xFFF1F8E9),
    fallbackIcon: Icons.precision_manufacturing,
  ),
  ModuleItem(
    title: 'Purchase',
    imagePath: 'assets/images/inventory.png',
    bgColor: Color(0xFFE1F5FE),
    fallbackIcon: Icons.shopping_bag,
    screenBuilder: (context) => purchase.Dashboard(isEmbedded: true, scaffoldKey: moduleScaffoldKey),
  ),
  ModuleItem(
    title: 'Dealer Mgmt',
    imagePath: 'assets/images/dealer_mgmt.png',
    bgColor: Color(0xFFFFF8E1),
    fallbackIcon: Icons.store_mall_directory,
  ),
];
