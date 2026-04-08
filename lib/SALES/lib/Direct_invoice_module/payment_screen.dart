import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_theme.dart';
import '/Proforma_Invoice_Module/product_model.dart';
import '/Proforma_Invoice_Module/selected_products_screen.dart';
import '/Proforma_Invoice_Module/invoice_view_screen.dart';



class InvoiceScreen extends StatefulWidget {
  final double totalAmount;
  final List<CatalogProduct> selectedProducts;

  const InvoiceScreen({
    super.key,
    required this.totalAmount,
    required this.selectedProducts,
  });
  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String _invoiceType   = 'Tax Invoice';
  String _taxType       = 'IGST';
  String _paymentMode   = 'Cash';
  bool   _tcsEnabled    = true;
  bool   _tdsEnabled    = false;
  bool   _markFullyPaid = false;
  bool   _advancedOpen  = false;

  // Default: collapsed (eye-off, no avatar, just name)
  bool _customerExpanded = false;
  // track expanded status per product
  int? _expandedProductIndex;

  final List<String> _invoiceTypes = ['Tax Invoice', 'Proforma Invoice', 'Credit Note'];
  final List<String> _taxTypes     = ['IGST', 'CGST + SGST', 'None'];
  final List<String> _paymentModes = ['Cash', 'UPI', 'NEFT', 'Cheque'];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sw = mq.size.width;
    final sh = mq.size.height;
    final hp = sw / 390;
    final vp = sh / 844;
    final sp = (sw / 390).clamp(0.8, 1.2);
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textWhite, size: 22 * sp),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text('Invoice',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 18 * sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            )),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16 * hp, vertical: 14 * vp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── 1. GENERAL INFORMATION ──────────────────────────────────
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                          icon: Icons.description_outlined,
                          iconColor: AppColors.blue,
                          label: 'General Information',
                          sp: sp,
                        ),
                        SizedBox(height: 14 * vp),
                        _FieldLabel('Invoice Type', sp: sp),
                        SizedBox(height: 6 * vp),
                        _OutlinedDropdown(
                          value: _invoiceType,
                          items: _invoiceTypes,
                          sp: sp, hp: hp, vp: vp,
                          onChanged: (v) => setState(() => _invoiceType = v!),
                        ),
                        SizedBox(height: 12 * vp),
                        _FieldLabel('Tax Type', sp: sp),
                        SizedBox(height: 6 * vp),
                        _OutlinedDropdown(
                          value: _taxType,
                          items: _taxTypes,
                          sp: sp, hp: hp, vp: vp,
                          onChanged: (v) => setState(() => _taxType = v!),
                        ),
                        SizedBox(height: 12 * vp),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _FieldLabel('Invoice Date', sp: sp),
                                  SizedBox(height: 6 * vp),
                                  _OutlinedField(value: '11 /24/2023', sp: sp, hp: hp, vp: vp),
                                ],
                              ),
                            ),
                            SizedBox(width: 10 * hp),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _FieldLabel('Invoice No.', sp: sp),
                                  SizedBox(height: 6 * vp),
                                  _OutlinedField(value: 'INV-2023-0042', sp: sp, hp: hp, vp: vp),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16 * vp),

                  // ── 2. CUSTOMER DETAILS ─────────────────────────────────────
                  Row(
                    children: [
                      Icon(Icons.person, color: AppColors.textDark, size: 20 * sp),
                      SizedBox(width: 6 * hp),
                      Text('Customer Details',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16 * sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          )),
                      const Spacer(),
                      Text('New Customer +',
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 13 * sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          )),
                    ],
                  ),
                  SizedBox(height: 10 * vp),

                  // Search bar
                  Container(
                    height: 46 * vp,
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.divider),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12 * hp),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: AppColors.textMuted, size: 18 * sp),
                        SizedBox(width: 8 * hp),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              fontSize: 13 * sp,
                              color: AppColors.textDark,
                              fontFamily: 'Poppins',
                            ),
                            decoration: InputDecoration(
                              hintText: 'Select customer name or ID...',
                              hintStyle: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13 * sp,
                                fontFamily: 'Poppins',
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10 * vp),

                  // ── CUSTOMER CARD ────────────────────────────────────────────
                  // Collapsed  → Name + eye_off  (NO avatar)
                  // Expanded   → Name + eye_on + details below
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.divider),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 3.5 * hp,
                            color: AppColors.blue,
                          ),
                        ),
                        Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12 * hp,
                                vertical: 2 * vp,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: AppColors.blue.withOpacity(0.12),
                                radius: 18 * sp,
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.blue,
                                  size: 20 * sp,
                                ),
                              ),
                              title: Text(
                                'Thanu - INV0001',
                                style: TextStyle(
                                  color: AppColors.textDark,
                                  fontSize: 14 * sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap: () => setState(() => _customerExpanded = !_customerExpanded),
                                child: Icon(
                                  _customerExpanded
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: _customerExpanded ? AppColors.blue : AppColors.textMuted,
                                  size: 22 * sp,
                                ),
                              ),
                            ),
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: _customerExpanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstChild: const SizedBox.shrink(),
                              secondChild: Padding(
                                padding: EdgeInsets.fromLTRB(14 * hp, 0, 14 * hp, 14 * vp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(color: AppColors.divider, height: 1),
                                    SizedBox(height: 14 * vp),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _FieldLabel('Contact Person', sp: sp),
                                              SizedBox(height: 5 * vp),
                                              _OutlinedField(value: 'Thanu', sp: sp, hp: hp, vp: vp),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10 * hp),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _FieldLabel('GST Number', sp: sp),
                                              SizedBox(height: 5 * vp),
                                              _OutlinedField(value: '27AAACR1234Z1', sp: sp, hp: hp, vp: vp),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12 * vp),
                                    _FieldLabel('Phone Number', sp: sp),
                                    SizedBox(height: 5 * vp),
                                    _OutlinedField(value: '98765 43210', sp: sp, hp: hp, vp: vp),
                                    SizedBox(height: 12 * vp),
                                    _FieldLabel('Billing Address', sp: sp),
                                    SizedBox(height: 5 * vp),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12 * hp, vertical: 10 * vp),
                                      decoration: BoxDecoration(
                                        color: AppColors.bgCardAlt,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppColors.divider),
                                      ),
                                      child: Text(
                                        '12/A, Industrial Estate, Phase II, Mumbai,\nMaharashtra - 400013',
                                        style: TextStyle(
                                          color: AppColors.textDark,
                                          fontSize: 13 * sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16 * vp),

                  // ── 3. PRODUCT ITEMS ────────────────────────────────────────
                  Row(
                    children: [
                      Icon(Icons.inventory_2_outlined, color: AppColors.blue, size: 20 * sp),
                      SizedBox(width: 6 * hp),
                      Text('Product Items',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16 * sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          )),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectedProductsScreen(
                                selectedProducts: widget.selectedProducts,
                                totalAmount: widget.totalAmount,
                              ),
                            ),
                          );
                        },
                        child: Text('view ${widget.selectedProducts.length} Items',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 13 * sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 10 * vp),

                  // ── PRODUCT CARDS (LIMIT TO 1) ──────────────────────────────
                  Column(
                    children: widget.selectedProducts.take(1).toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final product = entry.value;
                      final isExpanded = _expandedProductIndex == index;

                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 12 * vp),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.divider),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(14 * hp),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(product.name,
                                                style: TextStyle(
                                                  color: AppColors.textDark,
                                                  fontSize: 14 * sp,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Poppins',
                                                )),
                                            SizedBox(width: 8 * hp),
                                            GestureDetector(
                                              onTap: () => setState(() =>
                                                  _expandedProductIndex = isExpanded ? null : index),
                                              child: Icon(
                                                isExpanded
                                                    ? Icons.keyboard_arrow_up_rounded
                                                    : Icons.keyboard_arrow_down_rounded,
                                                color: const Color(0xFF3D5481),
                                                size: 22 * sp,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text('₹${(product.price * product.selectedQty).toInt()}',
                                                style: TextStyle(
                                                  color: AppColors.green,
                                                  fontSize: 14 * sp,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Poppins',
                                                )),
                                          ],
                                        ),
                                        Text('x ${product.selectedQty.toStringAsFixed(2)} OTH',
                                            style: TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 11 * sp,
                                              fontFamily: 'Poppins',
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: isExpanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstChild: const SizedBox.shrink(),
                              secondChild: Column(
                                children: [
                                  Divider(
                                      color: AppColors.divider,
                                      height: 1,
                                      indent: 14 * hp,
                                      endIndent: 14 * hp),
                                  _ProductDetailRow(
                                    icon: Icons.sell_outlined,
                                    iconColor: const Color(0xFF005BBF),
                                    label: 'PRICE',
                                    value: '₹${product.price.toInt()}.00',
                                    sp: sp,
                                    hp: hp,
                                    vp: vp,
                                  ),
                                  _ProductDetailRow(
                                    icon: Icons.inventory_2_outlined,
                                    iconColor: const Color(0xFF005BBF),
                                    label: 'QTY',
                                    value: '${product.selectedQty}',
                                    sp: sp,
                                    hp: hp,
                                    vp: vp,
                                  ),
                                  _ProductDetailRow(
                                    icon: Icons.percent,
                                    iconColor: const Color(0xFF005BBF),
                                    label: 'DISC%',
                                    value: '10%',
                                    sp: sp,
                                    hp: hp,
                                    vp: vp,
                                  ),
                                  SizedBox(height: 4 * vp),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 16 * vp),

                  // ── 4. TAX & COMPLIANCE ─────────────────────────────────────
                  Text('Tax & Compliance',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 16 * sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      )),
                  SizedBox(height: 10 * vp),
                  _TaxToggleCard(
                    iconBg: AppColors.blue.withOpacity(0.12),
                    icon: Icons.credit_card_outlined,
                    iconColor: AppColors.blue,
                    label: 'TCS', rateLabel: 'Collected Rate', rate: '0.1%',
                    enabled: _tcsEnabled,
                    sp: sp, hp: hp, vp: vp,
                    onChanged: (v) => setState(() => _tcsEnabled = v),
                  ),
                  SizedBox(height: 10 * vp),
                  _TaxToggleCard(
                    iconBg: AppColors.red.withOpacity(0.12),
                    icon: Icons.receipt_long_outlined,
                    iconColor: AppColors.red,
                    label: 'TDS', rateLabel: 'Deductible Rate', rate: '1.0%',
                    enabled: _tdsEnabled,
                    sp: sp, hp: hp, vp: vp,
                    onChanged: (v) => setState(() => _tdsEnabled = v),
                  ),
                  SizedBox(height: 14 * vp),

                  // ── 5. ADVANCED OPTIONS ─────────────────────────────────────
                  GestureDetector(
                    onTap: () => setState(() => _advancedOpen = !_advancedOpen),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14 * hp, vertical: 13 * vp),
                      decoration: BoxDecoration(
                        color: AppColors.bgCardAlt,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.tune_rounded, color: AppColors.textMuted, size: 18 * sp),
                              SizedBox(width: 8 * hp),
                              Text('ADVANCED OPTIONS',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12 * sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.6,
                                    fontFamily: 'Poppins',
                                  )),
                              const Spacer(),
                              Icon(
                                _advancedOpen
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textMuted,
                                size: 20 * sp,
                              ),
                            ],
                          ),
                          if (_advancedOpen) ...[
                            SizedBox(height: 12 * vp),
                            const Divider(height: 1),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.local_shipping_outlined, color: AppColors.textMuted, size: 18 * sp),
                              title: Text('Select Dispatch Address', style: TextStyle(fontSize: 13 * sp, color: AppColors.textMuted, fontFamily: 'Poppins')),
                              onTap: () => _showAddressPopup(context, sp, hp, vp),
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.document_scanner_outlined, color: AppColors.textMuted, size: 18 * sp),
                              title: Text('Add Reference', style: TextStyle(fontSize: 13 * sp, color: AppColors.textMuted, fontFamily: 'Poppins')),
                              onTap: () => _showReferencePopup(context, sp, hp, vp),
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.percent, color: AppColors.textMuted, size: 18 * sp),
                              title: Text('Add Extra Discount', style: TextStyle(fontSize: 13 * sp, color: AppColors.textMuted, fontFamily: 'Poppins')),
                              onTap: () => _showDiscountPopup(context, sp, hp, vp),
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.payments_outlined, color: AppColors.textMuted, size: 18 * sp),
                              title: Text('Delivery /Shipping Charges', style: TextStyle(fontSize: 13 * sp, color: AppColors.textMuted, fontFamily: 'Poppins')),
                              onTap: () => _showShippingPopup(context, sp, hp, vp),
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.inventory_2_outlined, color: AppColors.textMuted, size: 18 * sp),
                              title: Text('Packing Charges', style: TextStyle(fontSize: 13 * sp, color: AppColors.textMuted, fontFamily: 'Poppins')),
                              onTap: () => _showPackingPopup(context, sp, hp, vp),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16 * vp),

                  // ── 6. PAYMENT ──────────────────────────────────────────────
                  Text('Payment',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 16 * sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      )),
                  SizedBox(height: 10 * vp),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _FieldLabel('Amount Received', sp: sp),
                                  SizedBox(height: 6 * vp),
                                  _OutlinedField(value: '₹0.0', sp: sp, hp: hp, vp: vp),
                                ],
                              ),
                            ),
                            SizedBox(width: 10 * hp),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _FieldLabel('Payment Mode', sp: sp),
                                  SizedBox(height: 6 * vp),
                                  _OutlinedDropdown(
                                    value: _paymentMode,
                                    items: _paymentModes,
                                    sp: sp, hp: hp, vp: vp,
                                    onChanged: (v) => setState(() => _paymentMode = v!),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12 * vp),
                        _FieldLabel('Notes', sp: sp),
                        SizedBox(height: 6 * vp),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12 * hp, vertical: 12 * vp),
                          decoration: BoxDecoration(
                            color: AppColors.bgCardAlt,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Text('Add Notes',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13 * sp,
                                fontFamily: 'Poppins',
                              )),
                        ),
                        SizedBox(height: 14 * vp),
                        Row(
                          children: [
                            Container(
                              width:  26 * hp,
                              height: 26 * hp,
                              decoration: const BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.check, color: Colors.white, size: 15 * sp),
                            ),
                            SizedBox(width: 10 * hp),
                            Text('Mark as fully paid',
                                style: TextStyle(
                                  color: AppColors.textDark,
                                  fontSize: 14 * sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                )),
                            const Spacer(),
                            Switch.adaptive(
                              value: _markFullyPaid,
                              activeColor: AppColors.primary,
                              onChanged: (v) => setState(() => _markFullyPaid = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20 * vp),
                ],
              ),
            ),
          ),
          _BottomBar(
            sp: sp,
            hp: hp,
            vp: vp,
            totalAmount: widget.totalAmount,
            selectedProducts: widget.selectedProducts,
          ),
        ],
      ),
    );
  }
  void _showDiscountPopup(BuildContext context, double sp, double hp, double vp) {
    _showGenericPopup(context, 'Add Extra Discount', [
      _popupLabelField('Discount Value', '0', sp, hp, vp, showArrow: true),
    ], sp, hp, vp);
  }

  void _showShippingPopup(BuildContext context, double sp, double hp, double vp) {
    _showGenericPopup(context, 'Delivery / Shipping Charges', [
      _popupLabelField('Delivery Charge Value', '₹', sp, hp, vp, showArrow: true),
      SizedBox(height: 16 * vp),
      _popupLabelField('Tax %', '0', sp, hp, vp, showArrow: true),
      SizedBox(height: 16 * vp),
      _popupLabelField('Charges in ₹', '0.0', sp, hp, vp, showArrow: true),
      SizedBox(height: 16 * vp),
      _popupLabelField('', 'Without Tax', sp, hp, vp, showArrow: true),
    ], sp, hp, vp);
  }

  void _showPackingPopup(BuildContext context, double sp, double hp, double vp) {
    _showGenericPopup(context, 'Packing Charges', [
      _popupLabelField('Delivery Charge Value', '%', sp, hp, vp, showArrow: true),
      SizedBox(height: 16 * vp),
      _popupLabelField('Tax %', '0', sp, hp, vp, showArrow: true),
      SizedBox(height: 16 * vp),
      _popupLabelField('Charges in %', '0.0', sp, hp, vp, showArrow: true),
      SizedBox(height: 16 * vp),
      _popupLabelField('', 'Without Tax', sp, hp, vp, showArrow: true),
    ], sp, hp, vp);
  }

  void _showGenericPopup(BuildContext context, String title, List<Widget> children, double sp, double hp, double vp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: EdgeInsets.symmetric(horizontal: 20 * hp, vertical: 20 * vp),
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40 * hp, height: 4 * vp, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                SizedBox(height: 12 * vp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(fontSize: 16 * sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const Divider(),
                SizedBox(height: 16 * vp),
                ...children,
                SizedBox(height: 32 * vp),
                SizedBox(
                  width: double.infinity,
                  height: 50 * vp,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26A69A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15 * sp, fontFamily: 'Poppins')),
                  ),
                ),
                SizedBox(height: 10 * vp),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _popupLabelField(String label, String value, double sp, double hp, double vp, {bool showArrow = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: TextStyle(color: Colors.black87, fontSize: 13 * sp, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
          SizedBox(height: 8 * vp),
        ],
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16 * hp, vertical: 12 * vp),
          decoration: BoxDecoration(color: const Color(0xFFF2F4F6), borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Text(value, style: TextStyle(color: Colors.black87, fontSize: 14 * sp, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
              if (showArrow) ...[
                const Spacer(),
                Icon(Icons.arrow_drop_down, color: Colors.black87, size: 20 * sp),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _showReferencePopup(BuildContext context, double sp, double hp, double vp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20 * hp, vertical: 20 * vp),
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40 * hp,
                    height: 4 * vp,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 12 * vp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Reference', style: TextStyle(fontSize: 16 * sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const Divider(),
                SizedBox(height: 16 * vp),
                _popupField('Reference', sp, hp, vp),
                SizedBox(height: 24 * vp),
                SizedBox(
                  width: double.infinity,
                  height: 50 * vp,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26A69A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15 * sp, fontFamily: 'Poppins')),
                  ),
                ),
                SizedBox(height: 10 * vp),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddressPopup(BuildContext context, double sp, double hp, double vp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20 * hp, vertical: 20 * vp),
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40 * hp,
                    height: 4 * vp,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 12 * vp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Enter Address', style: TextStyle(fontSize: 16 * sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const Divider(),
                SizedBox(height: 16 * vp),
                _popupField('Title', sp, hp, vp),
                SizedBox(height: 8 * vp),
                Text('Autofill Company Name', style: TextStyle(color: const Color(0xFF005BBF), fontSize: 11 * sp, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                SizedBox(height: 16 * vp),
                Row(
                  children: [
                    Expanded(child: _popupField('Address line 1 *', sp, hp, vp)),
                    SizedBox(width: 12 * hp),
                    Expanded(child: _popupField('Address line 2 *', sp, hp, vp)),
                  ],
                ),
                SizedBox(height: 16 * vp),
                Row(
                  children: [
                    Expanded(child: _popupField('City', sp, hp, vp)),
                    SizedBox(width: 12 * hp),
                    Expanded(child: _popupField('State *', sp, hp, vp)),
                  ],
                ),
                SizedBox(height: 16 * vp),
                _popupField('Pincode *', sp, hp, vp),
                SizedBox(height: 24 * vp),
                SizedBox(
                  width: double.infinity,
                  height: 50 * vp,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26A69A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Save & Update', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15 * sp, fontFamily: 'Poppins')),
                  ),
                ),
                SizedBox(height: 10 * vp),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _popupField(String hint, double sp, double hp, double vp) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16 * hp, vertical: 12 * vp),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        hint,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 13 * sp, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  REUSABLE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.sp,
  });
  final IconData icon;
  final Color    iconColor;
  final String   label;
  final double   sp;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20 * sp),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16 * sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            )),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {required this.sp});
  final String text;
  final double sp;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 12 * sp,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
        ));
  }
}

class _OutlinedDropdown extends StatelessWidget {
  const _OutlinedDropdown({
    required this.value,
    required this.items,
    required this.sp,
    required this.hp,
    required this.vp,
    required this.onChanged,
  });
  final String       value;
  final List<String> items;
  final double       sp, hp, vp;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48 * vp,
      padding: EdgeInsets.symmetric(horizontal: 12 * hp),
      decoration: BoxDecoration(
        color: AppColors.bgCardAlt,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down_rounded,
            color: AppColors.textMuted, size: 20 * sp),
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: 14 * sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e,
              style: TextStyle(
                fontSize: 14 * sp,
                fontFamily: 'Poppins',
                color: AppColors.textDark,
              )),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _OutlinedField extends StatelessWidget {
  const _OutlinedField({
    required this.value,
    required this.sp,
    required this.hp,
    required this.vp,
  });
  final String value;
  final double sp, hp, vp;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48 * vp,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 12 * hp),
      decoration: BoxDecoration(
        color: AppColors.bgCardAlt,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(value,
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 13 * sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          )),
    );
  }
}

class _ProductDetailRow extends StatelessWidget {
  const _ProductDetailRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.sp,
    required this.hp,
    required this.vp,
  });
  final IconData icon;
  final Color iconColor;
  final String label, value;
  final double sp, hp, vp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14 * hp, vertical: 10 * vp),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18 * sp),
          SizedBox(width: 10 * hp),
          Text(label,
              style: TextStyle(
                color: const Color(0xFF005BBF),
                fontSize: 13 * sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              )),
          const Spacer(),
          Text(value,
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 13 * sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              )),
        ],
      ),
    );
  }
}

class _TaxToggleCard extends StatelessWidget {
  const _TaxToggleCard({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.rateLabel,
    required this.rate,
    required this.enabled,
    required this.sp,
    required this.hp,
    required this.vp,
    required this.onChanged,
  });
  final Color    iconBg, iconColor;
  final IconData icon;
  final String   label, rateLabel, rate;
  final bool     enabled;
  final double   sp, hp, vp;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14 * hp, vertical: 14 * vp),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width:  36 * hp,
                height: 36 * hp,
                decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: iconColor, size: 18 * sp),
              ),
              SizedBox(width: 10 * hp),
              Text(label,
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15 * sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  )),
              const Spacer(),
              Switch.adaptive(
                value: enabled,
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: onChanged,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10 * vp),
            child: const Divider(color: AppColors.divider, height: 1),
          ),
          Row(
            children: [
              Text(rateLabel,
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 13 * sp,
                    fontFamily: 'Poppins',
                  )),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 12 * hp, vertical: 5 * vp),
                decoration: BoxDecoration(
                  color: AppColors.bgCardAlt,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Text(rate,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 13 * sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.sp,
    required this.hp,
    required this.vp,
    required this.totalAmount,
    required this.selectedProducts,
  });
  final double sp, hp, vp;
  final double totalAmount;
  final List<CatalogProduct> selectedProducts;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20 * hp, 14 * vp, 20 * hp,
        14 * vp + MediaQuery.of(context).padding.bottom,
      ),
      color: AppColors.primary,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Sub Total : ₹${totalAmount.toInt()}',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 13 * sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    )),
                SizedBox(height: 4 * vp),
                Text('Total Amount : ${totalAmount.toInt()}',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 13 * sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    )),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceViewScreen(
                    selectedProducts: selectedProducts,
                    subtotal: totalAmount,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 22 * hp, vertical: 12 * vp),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.textWhite.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Create',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14 * sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      )),
                  SizedBox(width: 6 * hp),
                  Icon(Icons.arrow_forward_ios_rounded,
                      color: AppColors.primary, size: 14 * sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}