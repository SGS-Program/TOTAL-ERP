import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Invoice',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Detail',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Manage and track invoices',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FE),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'INVOICE',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF26A69A),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildInvoiceRow('Invoice No:', 'INV001'),
                  _buildInvoiceRow('Date:', '02-03-2026'),
                  _buildInvoiceRow('Order ID:', 'SO002'),
                  _buildInvoiceRow('CSIN:', 'CSIN001234'),
                  
                  const Divider(height: 32),
                  
                  Text(
                    'Sales ERP',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF26A69A),
                    ),
                  ),
                  Text(
                    'Enterprise Suite',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Smart global solution , Irugur',
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                  ),
                  Text(
                    'GSTIN: 29AAAAAA0000A1Z5',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),

                  const Divider(height: 32),

                  Row(
                    children: [
                      Text(
                        'Bill to: ',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0xFF26A69A)),
                      ),
                      Text(
                        'Sowmiya',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    'Customer ID: C001',
                    style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                  ),

                  SizedBox(height: 20.h),
                  
                  // Product Table
                  _buildProductTable(),

                  SizedBox(height: 20.h),

                  // Totals Section
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F9),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('Subtotal', '₹12,500'),
                        SizedBox(height: 8.h),
                        _buildSummaryRow('Tax (18%)', '₹2,250'),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₹14,750',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF26A69A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Status',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF26A69A),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'Paid',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            
            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(color: Color(0xFF26A69A)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Download',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: const Color(0xFF26A69A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Sent Invoice',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF26A69A).withOpacity(0.5)),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        children: [
          // Header
          Container(
            color: const Color(0xFFE8EAF6),
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                _buildCell('Product', flex: 2, isHeader: true),
                _buildCell('Qty', isHeader: true),
                _buildCell('Price', isHeader: true),
                _buildCell('Discount', isHeader: true),
              ],
            ),
          ),
          // Row
          Row(
            children: [
              _buildCell('ERP Standard License', flex: 2),
              _buildCell('3'),
              _buildCell('₹50,000'),
              _buildCell('10%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {int flex = 1, bool isHeader = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border(
            right: flex == 1 || text == 'Discount' ? BorderSide.none : BorderSide(color: const Color(0xFF26A69A).withOpacity(0.5)),
            left: text == 'Product' ? BorderSide.none : BorderSide(color: const Color(0xFF26A69A).withOpacity(0.5)),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            color: isHeader ? const Color(0xFF26A69A) : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF26A69A)),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
