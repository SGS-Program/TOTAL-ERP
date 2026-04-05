import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_theme.dart';



// ─── INVOICE SCREEN ───────────────────────────────────────────────────────────
class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});
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
  bool _productExpanded  = false;

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
                            color: AppColors.primary,
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border(
                        left: const BorderSide(color: AppColors.primary, width: 3.5),
                        top:    BorderSide(color: AppColors.divider),
                        right:  BorderSide(color: AppColors.divider),
                        bottom: BorderSide(color: AppColors.divider),
                      ),
                    ),
                    child: Column(
                      children: [
                        // ── Header row ──────────────────────────────────────
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12 * hp, vertical: 12 * vp),
                          child: Row(
                            children: [
                              // ✅ Avatar — only when EXPANDED
                              if (_customerExpanded) ...[
                                Container(
                                  width:  36 * hp,
                                  height: 36 * hp,
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySurface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.people_alt_outlined,
                                      color: AppColors.primary, size: 20 * sp),
                                ),
                                SizedBox(width: 10 * hp),
                              ],
                              Expanded(
                                child: Text(
                                  'Thanu - INV0001',
                                  style: TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 14 * sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              // Eye toggle
                              GestureDetector(
                                onTap: () => setState(
                                        () => _customerExpanded = !_customerExpanded),
                                child: Icon(
                                  _customerExpanded
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.textMuted,
                                  size: 20 * sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Expanded details ─────────────────────────────────
                        if (_customerExpanded) ...[
                          Divider(
                              color: AppColors.divider, height: 1,
                              indent: 12 * hp, endIndent: 12 * hp),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                12 * hp, 10 * vp, 12 * hp, 12 * vp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                SizedBox(height: 10 * vp),
                                _FieldLabel('Phone Number', sp: sp),
                                SizedBox(height: 5 * vp),
                                _OutlinedField(value: '98765 43210', sp: sp, hp: hp, vp: vp),
                                SizedBox(height: 10 * vp),
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
                        ],
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
                      Text('view 3 Items',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13 * sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          )),
                    ],
                  ),
                  SizedBox(height: 10 * vp),

                  // ── PRODUCT CARD ─────────────────────────────────────────────
                  Container(
                    width: double.infinity,
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
                                    Text('Industrial Flow Sensor v4',
                                        style: TextStyle(
                                          color: AppColors.textDark,
                                          fontSize: 14 * sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                        )),
                                    SizedBox(height: 3 * vp),
                                    Text('SKU: FS-400-X',
                                        style: TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 12 * sp,
                                          fontFamily: 'Poppins',
                                        )),
                                    SizedBox(height: 4 * vp),
                                    Text('Subtotal: ₹540.00',
                                        style: TextStyle(
                                          color: AppColors.green,
                                          fontSize: 13 * sp,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Poppins',
                                        )),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(
                                        () => _productExpanded = !_productExpanded),
                                child: Icon(
                                  _productExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textMuted,
                                  size: 22 * sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_productExpanded) ...[
                          Divider(color: AppColors.divider, height: 1,
                              indent: 14 * hp, endIndent: 14 * hp),
                          _ProductDetailRow(
                            icon: Icons.sell_outlined,
                            iconColor: AppColors.amber,
                            label: 'PRICE', value: '₹120.00',
                            sp: sp, hp: hp, vp: vp,
                          ),
                          Divider(color: AppColors.divider, height: 1,
                              indent: 14 * hp, endIndent: 14 * hp),
                          _ProductDetailRow(
                            icon: Icons.inventory_2_outlined,
                            iconColor: AppColors.blue,
                            label: 'QTY', value: '5',
                            sp: sp, hp: hp, vp: vp,
                          ),
                          Divider(color: AppColors.divider, height: 1,
                              indent: 14 * hp, endIndent: 14 * hp),
                          _ProductDetailRow(
                            icon: Icons.discount_outlined,
                            iconColor: AppColors.primary,
                            label: 'DISC%', value: '10%',
                            sp: sp, hp: hp, vp: vp,
                          ),
                          SizedBox(height: 4 * vp),
                        ],
                      ],
                    ),
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
                      child: Row(
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
          _BottomBar(sp: sp, hp: hp, vp: vp),
        ],
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
  final Color    iconColor;
  final String   label, value;
  final double   sp, hp, vp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14 * hp, vertical: 11 * vp),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16 * sp),
          SizedBox(width: 8 * hp),
          Text(label,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 12 * sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
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
  const _BottomBar({required this.sp, required this.hp, required this.vp});
  final double sp, hp, vp;

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
                Text('Sub Total : ₹4200',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 13 * sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    )),
                SizedBox(height: 4 * vp),
                Text('Total Amount : 4200',
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
            onTap: () {},
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