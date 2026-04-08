import 'package:flutter/material.dart';
import '/Proforma_Invoice_Module/all_products_screen.dart';

class GenerateInfoScreen extends StatefulWidget {
  const GenerateInfoScreen({super.key});

  @override
  State<GenerateInfoScreen> createState() => _GenerateInfoScreenState();
}

class _GenerateInfoScreenState extends State<GenerateInfoScreen> {
  String _selectedInvoiceType = 'Tax Invoice';
  String _selectedTaxType = 'IGST';
  final String _invoiceDate = '11/24/2023';
  final String _invoiceNo = 'INV-2023-0042';

  // ✅ Advanced Options toggle
  bool _advancedOptionsExpanded = false;

  // ✅ Eye toggle for customer details
  bool _isCustomerDetailsVisible = false;

  // ✅ Customer detail data
  final String _contactPerson = 'Thanu';
  final String _gstNumber = '27AAACR1234Z1';
  final String _phoneNumber = '98765 43210';
  final String _billingAddress =
      '12/A, Industrial Estate, Phase II, Mumbai, Maharashtra - 400013';

  final List<String> _invoiceTypes = [
    'Tax Invoice',
    'Proforma Invoice',
    'Credit Note',
    'Debit Note',
  ];

  final List<String> _taxTypes = [
    'IGST',
    'CGST + SGST',
    'None',
  ];

  // ✅ Advanced Options items with icons
  final List<Map<String, dynamic>> _advancedOptions = [
    {'label': 'Select Dispatch Address', 'icon': Icons.local_shipping_outlined},
    {'label': 'Add Reference', 'icon': Icons.assignment_outlined},
    {'label': 'Add Extra Discount', 'icon': Icons.discount_outlined},
    {'label': 'Delivery / Shipping Charges', 'icon': Icons.wallet_outlined},
    {'label': 'Packing Charges', 'icon': Icons.inventory_2_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final screenHeight = mq.size.height;
    final topPadding = mq.padding.top;
    final bottomPadding = mq.padding.bottom;

    final double horizontalPadding = screenWidth * 0.04;
    final double sectionSpacing = screenHeight * 0.015;
    final double cardPadding = screenWidth * 0.04;
    final double labelFontSize = screenWidth * 0.032;
    final double valueFontSize = screenWidth * 0.038;
    final double headerFontSize = screenWidth * 0.042;
    final double iconSize = screenWidth * 0.055;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(
            topPadding: topPadding,
            screenWidth: screenWidth,
            headerFontSize: headerFontSize,
            iconSize: iconSize,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: bottomPadding + screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: sectionSpacing),
                  _buildGeneralInfoCard(
                    screenWidth: screenWidth,
                    horizontalPadding: horizontalPadding,
                    cardPadding: cardPadding,
                    labelFontSize: labelFontSize,
                    valueFontSize: valueFontSize,
                    headerFontSize: headerFontSize,
                    iconSize: iconSize,
                    sectionSpacing: sectionSpacing,
                  ),
                  SizedBox(height: sectionSpacing),
                  _buildCustomerDetailsSection(
                    screenWidth: screenWidth,
                    horizontalPadding: horizontalPadding,
                    cardPadding: cardPadding,
                    labelFontSize: labelFontSize,
                    valueFontSize: valueFontSize,
                    headerFontSize: headerFontSize,
                    iconSize: iconSize,
                    sectionSpacing: sectionSpacing,
                  ),
                  SizedBox(height: sectionSpacing),
                  _buildAddProductsSection(
                    screenWidth: screenWidth,
                    horizontalPadding: horizontalPadding,
                    cardPadding: cardPadding,
                    valueFontSize: valueFontSize,
                    iconSize: iconSize,
                  ),
                  SizedBox(height: sectionSpacing),
                  _buildAdvancedOptionsSection(
                    screenWidth: screenWidth,
                    horizontalPadding: horizontalPadding,
                    cardPadding: cardPadding,
                    labelFontSize: labelFontSize,
                    valueFontSize: valueFontSize,
                    iconSize: iconSize,
                  ),
                  SizedBox(height: sectionSpacing),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── App Bar ──────────────────────────────────────────────────────────────

  Widget _buildAppBar({
    required double topPadding,
    required double screenWidth,
    required double headerFontSize,
    required double iconSize,
  }) {
    return Container(
      color: const Color(0xFF00897B),
      padding: EdgeInsets.only(
        top: topPadding + screenWidth * 0.02,
        bottom: screenWidth * 0.035,
        left: screenWidth * 0.03,
        right: screenWidth * 0.04,
      ),
      child: Row(
        children: [
          Icon(Icons.arrow_back, color: Colors.white, size: iconSize),
          SizedBox(width: screenWidth * 0.03),
          Text(
            'Invoice',
            style: TextStyle(
              color: Colors.white,
              fontSize: headerFontSize * 1.1,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ─── General Information Card ─────────────────────────────────────────────

  Widget _buildGeneralInfoCard({
    required double screenWidth,
    required double horizontalPadding,
    required double cardPadding,
    required double labelFontSize,
    required double valueFontSize,
    required double headerFontSize,
    required double iconSize,
    required double sectionSpacing,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Row(
              children: [
                Icon(Icons.description, color: const Color(0xFF0045BC), size: iconSize),
                SizedBox(width: screenWidth * 0.025),
                Text(
                  'General Information',
                  style: TextStyle(
                    fontSize: headerFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Invoice Type', labelFontSize),
                SizedBox(height: screenWidth * 0.015),
                _buildDropdown(
                  value: _selectedInvoiceType,
                  items: _invoiceTypes,
                  onChanged: (val) => setState(() => _selectedInvoiceType = val!),
                  screenWidth: screenWidth,
                  valueFontSize: valueFontSize,
                ),
                SizedBox(height: sectionSpacing),
                _buildLabel('Tax Type', labelFontSize),
                SizedBox(height: screenWidth * 0.015),
                _buildDropdown(
                  value: _selectedTaxType,
                  items: _taxTypes,
                  onChanged: (val) => setState(() => _selectedTaxType = val!),
                  screenWidth: screenWidth,
                  valueFontSize: valueFontSize,
                ),
                SizedBox(height: sectionSpacing),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Invoice Date', labelFontSize),
                          SizedBox(height: screenWidth * 0.015),
                          _buildReadOnlyField(
                            text: _invoiceDate,
                            screenWidth: screenWidth,
                            valueFontSize: valueFontSize,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Invoice No.', labelFontSize),
                          SizedBox(height: screenWidth * 0.015),
                          _buildReadOnlyField(
                            text: _invoiceNo,
                            screenWidth: screenWidth,
                            valueFontSize: valueFontSize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Customer Details Section ─────────────────────────────────────────────

  Widget _buildCustomerDetailsSection({
    required double screenWidth,
    required double horizontalPadding,
    required double cardPadding,
    required double labelFontSize,
    required double valueFontSize,
    required double headerFontSize,
    required double iconSize,
    required double sectionSpacing,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: const Color(0xFF0045BC), size: iconSize),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'Customer Details',
                    style: TextStyle(
                      fontSize: headerFontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'New Customer +',
                  style: TextStyle(
                    fontSize: labelFontSize,
                    color: const Color(0xFF0045BC),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: sectionSpacing * 0.8),

          // Search field
          Container(
            height: screenWidth * 0.12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenWidth * 0.025),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.03),
                Icon(Icons.search, color: Colors.grey.shade400, size: iconSize * 0.9),
                SizedBox(width: screenWidth * 0.025),
                Text(
                  'Select customer name or ID...',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: valueFontSize * 0.9,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: sectionSpacing * 0.8),

          // ✅ Customer tile + expandable details
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenWidth * 0.025),
              border: Border(
                left: BorderSide(
                  color: const Color(0xFF0045BC),
                  width: screenWidth * 0.012,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                // Customer name row with eye toggle
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: cardPadding,
                    vertical: screenWidth * 0.01,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFEEF0FB),
                    radius: screenWidth * 0.055,
                    child: Icon(
                      Icons.person,
                      color: const Color(0xFF0045BC),
                      size: iconSize,
                    ),
                  ),
                  title: Text(
                    'Thanu - INV0001',
                    style: TextStyle(
                      fontSize: valueFontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCustomerDetailsVisible = !_isCustomerDetailsVisible;
                      });
                    },
                    child: Icon(
                      _isCustomerDetailsVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: _isCustomerDetailsVisible
                          ? const Color(0xFF0045BC)
                          : Colors.grey.shade400,
                      size: iconSize,
                    ),
                  ),
                ),

                // ✅ Animated expandable customer details
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _isCustomerDetailsVisible
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: EdgeInsets.only(
                      left: cardPadding,
                      right: cardPadding,
                      bottom: cardPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: sectionSpacing * 0.8),

                        // Contact Person & GST Number
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Contact Person', labelFontSize),
                                  SizedBox(height: screenWidth * 0.015),
                                  _buildReadOnlyField(
                                    text: _contactPerson,
                                    screenWidth: screenWidth,
                                    valueFontSize: valueFontSize,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('GST Number', labelFontSize),
                                  SizedBox(height: screenWidth * 0.015),
                                  _buildReadOnlyField(
                                    text: _gstNumber,
                                    screenWidth: screenWidth,
                                    valueFontSize: valueFontSize,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: sectionSpacing * 0.8),

                        // Phone Number
                        _buildLabel('Phone Number', labelFontSize),
                        SizedBox(height: screenWidth * 0.015),
                        _buildReadOnlyField(
                          text: _phoneNumber,
                          screenWidth: screenWidth,
                          valueFontSize: valueFontSize,
                        ),

                        SizedBox(height: sectionSpacing * 0.8),

                        // Billing Address
                        _buildLabel('Billing Address', labelFontSize),
                        SizedBox(height: screenWidth * 0.015),
                        _buildReadOnlyField(
                          text: _billingAddress,
                          screenWidth: screenWidth,
                          valueFontSize: valueFontSize,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Add Products Section ─────────────────────────────────────────────────

  Widget _buildAddProductsSection({
    required double screenWidth,
    required double horizontalPadding,
    required double cardPadding,
    required double valueFontSize,
    required double iconSize,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: cardPadding,
          vertical: screenWidth * 0.01,
        ),
        leading: Container(
          width: screenWidth * 0.1,
          height: screenWidth * 0.1,
          decoration: BoxDecoration(
            color: const Color(0xFF0045BC).withOpacity(0.1),
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
          ),
          child: Icon(
            Icons.inventory_2,
            color: const Color(0xFF0045BC),
            size: iconSize,
          ),
        ),
        title: Text(
          'Add Products',
          style: TextStyle(
            fontSize: valueFontSize,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey.shade500,
          size: iconSize * 1.2,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const InvoiceCatalogScreen(),
            ),
          );
        },
      ),
    );
  }

  // ─── Advanced Options Section ─────────────────────────────────────────────

  Widget _buildAdvancedOptionsSection({
    required double screenWidth,
    required double horizontalPadding,
    required double cardPadding,
    required double labelFontSize,
    required double valueFontSize,
    required double iconSize,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.025),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // ✅ Advanced Options header row
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: cardPadding,
              vertical: screenWidth * 0.005,
            ),
            leading: Icon(
              Icons.tune,
              color: Colors.grey.shade600,
              size: iconSize,
            ),
            title: Text(
              'ADVANCED OPTIONS',
              style: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
                letterSpacing: 0.8,
              ),
            ),
            trailing: Icon(
              _advancedOptionsExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.grey.shade500,
              size: iconSize * 1.1,
            ),
            onTap: () =>
                setState(() => _advancedOptionsExpanded = !_advancedOptionsExpanded),
          ),

          // ✅ Animated expandable advanced option items
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _advancedOptionsExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [

                ..._advancedOptions.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final Map<String, dynamic> option = entry.value;
                  final bool isLast = index == _advancedOptions.length - 1;

                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: cardPadding,
                          vertical: screenWidth * 0.001,
                        ),
                        leading: Icon(
                          option['icon'] as IconData,
                          color: Colors.grey.shade600,
                          size: iconSize,
                        ),
                        title: Text(
                          option['label'] as String,
                          style: TextStyle(
                            fontSize: valueFontSize,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Shared Helpers ───────────────────────────────────────────────────────

  Widget _buildLabel(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required double screenWidth,
    required double valueFontSize,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.035,
        vertical: screenWidth * 0.01,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFFF2F4F6),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey.shade600,
            size: screenWidth * 0.06,
          ),
          style: TextStyle(
            fontSize: valueFontSize,
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w500,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String text,
    required double screenWidth,
    required double valueFontSize,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.035,
        vertical: screenWidth * 0.032,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: valueFontSize,
          color: const Color(0xFF1A1A2E),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}