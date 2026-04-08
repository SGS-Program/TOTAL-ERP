import 'package:flutter/material.dart';
import '/Proforma_Invoice_Module/product_model.dart';
import '/Proforma_Invoice_Module/invoice_view_screen.dart';

class SelectedProductsScreen extends StatefulWidget {
  final List<CatalogProduct> selectedProducts;
  final double totalAmount;

  const SelectedProductsScreen({
    super.key,
    required this.selectedProducts,
    required this.totalAmount,
  });

  @override
  State<SelectedProductsScreen> createState() => _SelectedProductsScreenState();
}

class _SelectedProductsScreenState extends State<SelectedProductsScreen> {
  int? _expandedProductIndex;

  @override
  Widget build(BuildContext context) {
    // Screen sizing
    final mq = MediaQuery.of(context);
    final sp = mq.size.width / 375;
    final hp = mq.size.width / 375;
    final vp = mq.size.height / 812;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Invoice',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18 * sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16 * hp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── HEADER ──────────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6 * hp),
                        decoration: BoxDecoration(
                          color: const Color(0xFF005BBF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.inventory_2, color: Colors.white, size: 18 * sp),
                      ),
                      SizedBox(width: 8 * hp),
                      Text(
                        'View Product Items',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16 * sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12 * vp),

                  // ── PRODUCT LIST ─────────────────────────────────────
                  Column(
                    children: widget.selectedProducts.asMap().entries.map((entry) {
                      final index = entry.key;
                      final product = entry.value;
                      final isExpanded = _expandedProductIndex == index;

                      return Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 12 * vp),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(14 * hp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          color: const Color(0xFF1A1A2E),
                                          fontSize: 14 * sp,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
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
                                            color: const Color(0xFF005BBF),
                                            fontSize: 14 * sp,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Poppins',
                                          )),
                                    ],
                                  ),
                                  Text('x ${product.selectedQty.toStringAsFixed(2)} OTH',
                                      style: TextStyle(
                                        color: const Color(0xFF005BBF).withOpacity(0.6),
                                        fontSize: 11 * sp,
                                        fontFamily: 'Poppins',
                                      )),
                                ],
                              ),
                            ),
                            if (isExpanded)
                              Padding(
                                padding: EdgeInsets.fromLTRB(14 * hp, 0, 14 * hp, 14 * hp),
                                child: Column(
                                  children: [
                                    const Divider(height: 1, color: Colors.black12),
                                    SizedBox(height: 12 * vp),
                                    _detailRow(Icons.sell_outlined, const Color(0xFF005BBF), 'PRICE', '₹${product.price.toInt()}.00', sp, hp),
                                    SizedBox(height: 8 * vp),
                                    _detailRow(Icons.inventory_2_outlined, const Color(0xFF005BBF), 'QTY', '${product.selectedQty}', sp, hp),
                                    SizedBox(height: 8 * vp),
                                    _detailRow(Icons.percent, const Color(0xFF005BBF), 'DISC%', '10%', sp, hp),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 16 * vp),

                  // ── PAYMENT SECTION ──────────────────────────────────
                  Text(
                    'Payment',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18 * sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 12 * vp),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16 * hp),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _inputField('Amount Received', '₹0.0', sp, hp, vp),
                            ),
                            SizedBox(width: 12 * hp),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment Mode',
                                    style: TextStyle(
                                      color: const Color(0xFF3D5481),
                                      fontSize: 12 * sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 6 * vp),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10 * hp, vertical: 8 * vp),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Cash', style: TextStyle(fontSize: 13 * sp, fontFamily: 'Poppins')),
                                        Icon(Icons.keyboard_arrow_down, size: 18 * sp),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16 * vp),
                        _inputField('Notes', 'Add Notes', sp, hp, vp),
                        SizedBox(height: 16 * vp),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFC8E6C9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.check, color: const Color(0xFF2E7D32), size: 14 * sp),
                            ),
                            SizedBox(width: 8 * hp),
                            Text(
                              'Mark as fully paid',
                              style: TextStyle(
                                color: const Color(0xFF1E2432),
                                fontSize: 13 * sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const Spacer(),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: false,
                                onChanged: (v) {},
                                activeColor: const Color(0xFF26A69A),
                              ),
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
          
          // ── BOTTOM SUMMARY ──────────────────────────────────
          Container(
            padding: EdgeInsets.all(16 * hp),
            decoration: const BoxDecoration(
              color: Color(0xFF26A69A),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sub Total : ₹${widget.totalAmount.toInt()}',
                      style: TextStyle(color: Colors.white, fontSize: 14 * sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                    ),
                    Text(
                      'Total Amount : ${widget.totalAmount.toInt()}',
                      style: TextStyle(color: Colors.white, fontSize: 14 * sp, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvoiceViewScreen(
                          selectedProducts: widget.selectedProducts,
                          subtotal: widget.totalAmount,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF26A69A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(horizontal: 20 * hp, vertical: 10 * vp),
                  ),
                  child: Row(
                    children: [
                      Text('Create', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 * sp, fontFamily: 'Poppins')),
                      SizedBox(width: 4 * hp),
                      Icon(Icons.chevron_right, size: 18 * sp),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, Color color, String label, String value, double sp, double hp) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18 * sp),
        SizedBox(width: 8 * hp),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13 * sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF1E2432),
            fontSize: 13 * sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _inputField(String label, String hint, double sp, double hp, double vp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF3D5481),
            fontSize: 12 * sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 6 * vp),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10 * hp, vertical: 8 * vp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(hint, style: TextStyle(color: Colors.grey, fontSize: 13 * sp, fontFamily: 'Poppins')),
        ),
      ],
    );
  }
}
