import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Widget/custome_buttombar.dart';
import '../ProductScreen/add_product.dart';
import '../ProductScreen/edit_product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
          'Product',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.tune, color: Colors.black87, size: 24.sp),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
                contentPadding: EdgeInsets.symmetric(vertical: 0.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: const BorderSide(color: Color(0xFF26A69A)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: const BorderSide(color: Color(0xFF26A69A)),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.65, // Adjusted to prevent overflow
              children: [
                _buildProductCard(
                  'Product A',
                  'Electronics',
                  '₹2,500',
                  '43',
                  'Low Stock',
                  const Color(0xFFA1887F),
                  'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=500&auto=format&fit=crop',
                ),
                _buildProductCard(
                  'Product B',
                  'Clothing',
                  '₹1,200',
                  '150',
                  'In Stock',
                  Colors.green,
                  'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?q=80&w=500&auto=format&fit=crop',
                ),
                _buildProductCard(
                  'Product C',
                  'Food',
                  '₹2,500',
                  '80',
                  'In Stock',
                  Colors.green,
                  'https://images.unsplash.com/photo-1490818387583-1baba5e638af?q=80&w=500&auto=format&fit=crop',
                ),
                _buildProductCard(
                  'Product D',
                  'Electronics',
                  '₹2,500',
                  '43',
                  'Low Stock',
                  const Color(0xFFA1887F),
                  'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=500&auto=format&fit=crop',
                ),
                _buildProductCard(
                  'Product E',
                  'Furniture',
                  '₹2,500',
                  '43',
                  'Low Stock',
                  const Color(0xFFA1887F),
                  'https://images.unsplash.com/photo-1524758631624-e2822e304c36?q=80&w=500&auto=format&fit=crop',
                ),
                _buildProductCard(
                  'Product F',
                  'Electronics',
                  '₹2,500',
                  '43',
                  'Low Stock',
                  const Color(0xFFA1887F),
                  'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=500&auto=format&fit=crop',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 56.w,
        height: 56.h,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AddProductScreen(),
            );
          },
          backgroundColor: const Color(0xFF26A69A),
          shape: const CircleBorder(),
          child: Icon(Icons.add, color: Colors.white, size: 30.sp),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 3),
    );
  }

  Widget _buildProductCard(
    String name,
    String category,
    String price,
    String stock,
    String status,
    Color statusColor,
    String imageUrl,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Image.network(
                  imageUrl,
                  height: 100.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 100.h,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, color: Colors.grey, size: 40.sp),
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditProductScreen(
                        productName: name,
                        category: category,
                        price: price,
                        stock: stock,
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_note,
                      size: 18.sp,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF26A69A),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 12.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          stock,
                          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
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
}
