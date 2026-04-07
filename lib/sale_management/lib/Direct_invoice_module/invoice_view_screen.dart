import 'package:flutter/material.dart';
import 'product_model.dart';

class InvoiceViewScreen extends StatefulWidget {
  final List<CatalogProduct> selectedProducts;
  final double subtotal;

  const InvoiceViewScreen({
    super.key,
    required this.selectedProducts,
    required this.subtotal,
  });

  @override
  State<InvoiceViewScreen> createState() => _InvoiceViewScreenState();
}

class _InvoiceViewScreenState extends State<InvoiceViewScreen> {
  bool _isCustomerExpanded = false;
  int? _expandedItemIndex;
  bool _isFabExpanded = false;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sp = mq.size.width / 375;
    final hp = mq.size.width / 375;
    final vp = mq.size.height / 812;

    // Calculation constants for UI fidelity
    final double discount = widget.subtotal * 0.05;
    final double taxableAmount = widget.subtotal - discount;
    final double tax = taxableAmount * 0.18;
    const double shipping = 1500.0;
    final double tcs = widget.subtotal * 0.001;
    const double tds = 0.0;
    final double finalPayable = taxableAmount + tax + shipping + tcs - tds;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INV - 1',
              style: TextStyle(color: Colors.white, fontSize: 16 * sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
            Row(
              children: [
                Text(
                  'Invoice - ',
                  style: TextStyle(color: Colors.white, fontSize: 11 * sp, fontFamily: 'Poppins'),
                ),
                Text(
                  'Pending',
                  style: TextStyle(color: Colors.orange, fontSize: 11 * sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.edit, color: Colors.white, size: 20), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.white, size: 20), onPressed: () => _showMoreOptions(context)),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16 * hp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── CUSTOMER DETAILS ───────────────────────
                  Row(
                    children: [
                      const Icon(Icons.person, color: Color(0xFF005BBF), size: 20),
                      SizedBox(width: 8 * hp),
                      Text('Customer Details', style: TextStyle(fontSize: 15 * sp, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                    ],
                  ),
                  SizedBox(height: 12 * vp),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(left: BorderSide(color: Color(0xFF005BBF), width: 5)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(backgroundColor: const Color(0xFFEEF0FB), radius: 20 * hp, child: const Icon(Icons.person, color: Color(0xFF005BBF), size: 22)),
                          title: Text('Thanu - INV0001', style: TextStyle(fontSize: 14 * sp, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                          trailing: IconButton(
                            icon: Icon(_isCustomerExpanded ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: _isCustomerExpanded ? const Color(0xFF005BBF) : Colors.grey),
                            onPressed: () => setState(() => _isCustomerExpanded = !_isCustomerExpanded),
                          ),
                        ),
                        if (_isCustomerExpanded)
                          Padding(
                            padding: EdgeInsets.fromLTRB(16 * hp, 0, 16 * hp, 16 * vp),
                            child: Column(
                              children: [
                                const Divider(),
                                SizedBox(height: 12 * vp),
                                Row(
                                  children: [
                                    Expanded(child: _customerField('Contact Person', 'Thanu', sp, hp, vp)),
                                    SizedBox(width: 12 * hp),
                                    Expanded(child: _customerField('GST Number', '27AAACR1234Z1', sp, hp, vp)),
                                  ],
                                ),
                                SizedBox(height: 12 * vp),
                                _customerField('Phone Number', '98765 43210', sp, hp, vp),
                                SizedBox(height: 12 * vp),
                                _customerField('Billing Address', '12/A, Industrial Estate, Phase II, Mumbai, Maharashtra - 400013', sp, hp, vp),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24 * vp),
                  // ── ITEMS SECTION ──────────────────────────
                  Text('Item(${widget.selectedProducts.length})', style: TextStyle(fontSize: 15 * sp, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                  SizedBox(height: 12 * vp),
                  Container(
                    decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(12)),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.selectedProducts.length,
                      separatorBuilder: (c, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final p = widget.selectedProducts[index];
                        final isExpanded = _expandedItemIndex == index;
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16 * hp, vertical: 8 * vp),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(p.name, style: TextStyle(fontSize: 14 * sp, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                                            SizedBox(width: 8 * hp),
                                            GestureDetector(
                                              onTap: () => setState(() => _expandedItemIndex = isExpanded ? null : index),
                                              child: Icon(
                                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                size: 22 * sp,
                                                color: const Color(0xFF3D5481),
                                              ),
                                            ),
                                            const Spacer(),
                                            Text('₹${(p.price * p.selectedQty).toInt()}', style: TextStyle(color: const Color.fromARGB(255, 113, 191, 132), fontSize: 14 * sp, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                                          ],
                                        ),
                                        Text('x ${p.selectedQty.toStringAsFixed(2)} OTH', style: TextStyle(color: const Color(0xFF005BBF).withOpacity(0.6), fontSize: 11 * sp, fontFamily: 'Poppins')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              firstChild: const SizedBox.shrink(),
                              secondChild: Padding(
                                padding: EdgeInsets.fromLTRB(16 * hp, 0, 16 * hp, 16 * vp),
                                child: Column(
                                  children: [
                                    _invoiceItemDetail(Icons.sell_outlined, 'PRICE', '₹${p.price.toInt()}.00', sp, hp),
                                    SizedBox(height: 8 * vp),
                                    _invoiceItemDetail(Icons.inventory_2_outlined, 'QTY', '${p.selectedQty}', sp, hp),
                                    SizedBox(height: 8 * vp),
                                    _invoiceItemDetail(Icons.percent, 'DISC%', '10%', sp, hp),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24 * vp),
                  // ── BILL SUMMARY CARD ──────────────────────
                  Container(
                    padding: EdgeInsets.all(20 * hp),
                    margin: EdgeInsets.only(bottom: 120 * vp),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bill Summary', style: TextStyle(fontSize: 16 * sp, fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
                        SizedBox(height: 20 * vp),
                        _summaryRow('Subtotal', '₹ ${widget.subtotal.toStringAsFixed(2)}', sp, Colors.black87),
                        SizedBox(height: 12 * vp),
                        _summaryRow('Discount (5%)', '- ₹ ${discount.toStringAsFixed(2)}', sp, Colors.red),
                        SizedBox(height: 12 * vp),
                        _summaryRow('CGST + SGST (18%)', '₹ ${tax.toStringAsFixed(2)}', sp, Colors.black87),
                        SizedBox(height: 12 * vp),
                        _summaryRow('Shipping', '₹ ${shipping.toStringAsFixed(2)}', sp, Colors.black87),
                        SizedBox(height: 12 * vp),
                        _summaryRow('TCS (+)', '₹ ${tcs.toStringAsFixed(2)}', sp, const Color(0xFF005BBF), hasInfo: true),
                        SizedBox(height: 12 * vp),
                        _summaryRow('TDS (-)', '₹ ${tds.toStringAsFixed(2)}', sp, Colors.black87, hasInfo: true),
                        SizedBox(height: 20 * vp),
                        const Divider(),
                        SizedBox(height: 16 * vp),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Final Payable', style: TextStyle(fontSize: 15 * sp, fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('TOTAL AMOUNT DUE', style: TextStyle(fontSize: 9 * sp, color: Colors.grey, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                                Text('₹ ${finalPayable.toStringAsFixed(2)}', style: TextStyle(color: const Color(0xFF2E7D32), fontSize: 18 * sp, fontWeight: FontWeight.w900, fontFamily: 'Poppins')),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── SPEED DIAL IN STACK ────────────────────
          Positioned(
            bottom: 20 * vp,
            right: 20 * hp,
            child: _buildSpeedDial(sp, hp, vp),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedDial(double sp, double hp, double vp) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isFabExpanded) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               _dialItem(icon: Icons.currency_rupee, label: 'Record', sp: sp, vp: vp),
               SizedBox(width: 10 * hp),
               _dialItem(icon: Icons.picture_as_pdf_outlined, label: 'PDF View', sp: sp, vp: vp, customLabel: 'PDF\nView'),
            ],
          ),
          SizedBox(height: 10 * vp),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialItem(icon: Icons.share, label: 'Share', sp: sp, vp: vp),
              SizedBox(width: 10 * hp),
              _mainFabToggle(),
            ],
          ),
        ] else
          _mainFabToggle(),
      ],
    );
  }

  Widget _mainFabToggle() {
    return FloatingActionButton(
      heroTag: 'main_fab',
      onPressed: () => setState(() => _isFabExpanded = !_isFabExpanded),
      backgroundColor: const Color(0xFF26A69A),
      elevation: 4,
      child: Icon(_isFabExpanded ? Icons.close : Icons.add, color: Colors.white, size: _isFabExpanded ? 28 : 30),
    );
  }

  Widget _dialItem({required IconData icon, required String label, required double sp, required double vp, String? customLabel}) {
    return Container(
      width: 56 * sp,
      height: 56 * sp,
      decoration: const BoxDecoration(color: Color(0xFF26A69A), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 18 * sp),
          Text(customLabel ?? label, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 9 * sp, fontWeight: FontWeight.bold, height: 1.1, fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  void _showAttachmentPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final mq = MediaQuery.of(context);
        final sp = mq.size.width / 375;
        final hp = mq.size.width / 375;
        final vp = mq.size.height / 812;
        return Container(
          height: 180 * vp,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            children: [
              SizedBox(height: 12 * vp),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 30 * vp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _mediaOption(Icons.camera_alt_outlined, 'Camera', sp, hp, vp),
                  _mediaOption(Icons.upload_outlined, 'Upload File', sp, hp, vp),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConvertPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final mq = MediaQuery.of(context);
        final sp = mq.size.width / 375;
        final hp = mq.size.width / 375;
        final vp = mq.size.height / 812;
        return Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: EdgeInsets.symmetric(horizontal: 20 * hp, vertical: 12 * vp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 20 * vp),
              _convertRow(Icons.sync_alt, 'Convert To Sales Return', sp, hp, vp),
              _convertRow(Icons.sync_alt, 'Convert To Sales Order', sp, hp, vp),
              _convertRow(Icons.sync_alt, 'Convert To Delivery Challan', sp, hp, vp),
              _convertRow(Icons.sync_alt, 'Convert To Quotation', sp, hp, vp),
              SizedBox(height: 20 * vp),
            ],
          ),
        );
      },
    );
  }

  Widget _mediaOption(IconData icon, String label, double sp, double hp, double vp) {
    return Column(
      children: [
        Container(
          width: 70 * sp,
          height: 70 * sp,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF26A69A))),
          child: Icon(icon, color: const Color(0xFF26A69A), size: 28 * sp),
        ),
        SizedBox(height: 12 * vp),
        Text(label, style: TextStyle(color: const Color(0xFF26A69A), fontSize: 13 * sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
      ],
    );
  }

  Widget _convertRow(IconData icon, String label, double sp, double hp, double vp) {
    return Container(
      margin: EdgeInsets.only(bottom: 12 * vp),
      padding: EdgeInsets.symmetric(horizontal: 16 * hp, vertical: 12 * vp),
      decoration: BoxDecoration(color: const Color(0xFFE0F7FA).withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(Icons.sync_alt, color: const Color(0xFF00ACC1), size: 20 * sp),
          SizedBox(width: 12 * hp),
          Text(label, style: TextStyle(fontSize: 14 * sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final mq = MediaQuery.of(context);
        final sp = mq.size.width / 375;
        final hp = mq.size.width / 375;
        final vp = mq.size.height / 812;
        return Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: EdgeInsets.symmetric(horizontal: 20 * hp, vertical: 20 * vp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              _sectionHeader('OTHERS', const Color(0xFF005BBF), sp),
              SizedBox(height: 20 * vp),
              Wrap(
                spacing: 20 * hp,
                runSpacing: 20 * vp,
                children: [
                  _OptionItem(icon: Icons.description_outlined, label: 'Reference', iconColor: const Color(0xFF42A5F5), sp: sp, vp: vp),
                  _OptionItem(
                    icon: Icons.attach_file,
                    label: 'Attachments',
                    iconColor: const Color(0xFF42A5F5),
                    sp: sp,
                    vp: vp,
                    onTap: () {
                      Navigator.pop(context);
                      _showAttachmentPopup(context);
                    },
                  ),
                  _OptionItem(icon: Icons.print_outlined, label: 'Print', iconColor: const Color(0xFF42A5F5), sp: sp, vp: vp),
                  _OptionItem(icon: Icons.email_outlined, label: 'Send Email', iconColor: const Color(0xFF42A5F5), sp: sp, vp: vp),
                  _OptionItem(icon: Icons.sms_outlined, label: 'Send SMS', iconColor: const Color(0xFF42A5F5), sp: sp, vp: vp),
                ],
              ),
              SizedBox(height: 30 * vp),
              _sectionHeader('CONVERT', const Color(0xFF005BBF), sp),
              SizedBox(height: 20 * vp),
              Wrap(
                spacing: 20 * hp,
                runSpacing: 20 * vp,
                children: [
                  _OptionItem(
                    icon: Icons.replay_rounded,
                    label: 'Convert',
                    iconColor: const Color(0xFF26A69A),
                    sp: sp,
                    vp: vp,
                    onTap: () {
                      Navigator.pop(context);
                      _showConvertPopup(context);
                    },
                  ),
                  _OptionItem(icon: Icons.local_shipping_outlined, label: 'Delivery Challan', iconColor: const Color(0xFFFFA726), sp: sp, vp: vp),
                  _OptionItem(icon: Icons.qr_code_2, label: 'Generate QR Code', iconColor: const Color(0xFF26C6DA), sp: sp, vp: vp),
                  _OptionItem(icon: Icons.receipt_long, label: 'Convert E-Way Bill', iconColor: const Color(0xFF9CCC65), sp: sp, vp: vp),
                  _OptionItem(icon: Icons.computer, label: 'Convert E-Invoice', iconColor: const Color(0xFF78909C), sp: sp, vp: vp),
                ],
              ),
              SizedBox(height: 30 * vp),
              _sectionHeader('CANCEL', const Color(0xFFE53935), sp),
              SizedBox(height: 20 * vp),
              Row(children: [_OptionItem(icon: Icons.close_rounded, label: 'Cancel Invoice', iconColor: const Color(0xFFEF9A9A), sp: sp, vp: vp, isCancel: true)]),
              SizedBox(height: 20 * vp),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String label, Color color, double sp) {
    return Row(children: [Text(label, style: TextStyle(color: color, fontSize: 16 * sp, fontWeight: FontWeight.w800, letterSpacing: 0.8, fontFamily: 'Poppins')), const SizedBox(width: 10), const Expanded(child: Divider())]);
  }

  Widget _customerField(String label, String value, double sp, double hp, double vp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12 * sp, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
        SizedBox(height: 6 * vp),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12 * hp, vertical: 10 * vp),
          decoration: BoxDecoration(color: const Color(0xFFF2F4F6), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
          child: Text(value, style: TextStyle(color: const Color(0xFF1A1A2E), fontSize: 13 * sp, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
        ),
      ],
    );
  }

  Widget _invoiceItemDetail(IconData icon, String label, String value, double sp, double hp) {
    return Row(children: [Icon(icon, color: const Color(0xFF005BBF), size: 18 * sp), SizedBox(width: 8 * hp), Text(label, style: TextStyle(color: const Color(0xFF005BBF), fontSize: 13 * sp, fontWeight: FontWeight.w700, fontFamily: 'Poppins')), const Spacer(), Text(value, style: TextStyle(color: const Color(0xFF1E2432), fontSize: 13 * sp, fontWeight: FontWeight.w600, fontFamily: 'Poppins'))]);
  }

  Widget _summaryRow(String label, String value, double sp, Color valueColor, {bool hasInfo = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Text(label, style: TextStyle(color: Colors.black54, fontSize: 13 * sp, fontWeight: FontWeight.w500, fontFamily: 'Poppins')), if (hasInfo) ...[const SizedBox(width: 4), Icon(Icons.info_outline, size: 14 * sp, color: Colors.grey)]]), Text(value, style: TextStyle(color: valueColor, fontSize: 13 * sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins'))]);
  }
}

class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final double sp, vp;
  final bool isCancel;
  final VoidCallback? onTap;
  const _OptionItem({required this.icon, required this.label, required this.iconColor, required this.sp, required this.vp, this.isCancel = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80 * sp,
        child: Column(
          children: [
            Container(width: 50 * sp, height: 40 * sp, decoration: BoxDecoration(color: isCancel ? const Color(0xFFEF9A9A).withOpacity(0.3) : const Color(0xFFE0F7FA), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: isCancel ? Colors.red : iconColor, size: 22 * sp)),
            SizedBox(height: 6 * vp),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10 * sp, fontWeight: FontWeight.w600, color: Colors.black87, fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}
