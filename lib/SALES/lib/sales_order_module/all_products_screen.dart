import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '/Proforma_Invoice_Module/payment_screen.dart';
export '/Proforma_Invoice_Module/product_model.dart';
import '/Proforma_Invoice_Module/product_model.dart';

class InvoiceCatalogScreen extends StatefulWidget {
  final bool isReadOnly;
  const InvoiceCatalogScreen({super.key, this.isReadOnly = false});

  @override
  State<InvoiceCatalogScreen> createState() => _InvoiceCatalogScreenState();
}

class _InvoiceCatalogScreenState extends State<InvoiceCatalogScreen> {
  final Color primaryColor = const Color(0xFF26A69A);
  String _selectedCategory = 'ALL';

  final List<String> _categories = [
    'ALL',
    'SOFTWARE',
    'SERVICES',
    'LICENSES',
    'HARDWARE',
    'NETWORK'
  ];

  final List<CatalogProduct> _products = [
    CatalogProduct(
      id: '1',
      name: 'Enterprise Cloud Server - Pro X',
      imageUrl: 'https://images.unsplash.com/photo-1558494949-ef8b565b1d40?w=500&auto=format',
      stock: 30,
      price: 4200.0,
      category: 'HARDWARE',
    ),
    CatalogProduct(
      id: '2',
      name: 'L2 Managed Switch - 48 Port',
      imageUrl: 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=500&auto=format',
      stock: 30,
      price: 4200.0,
      category: 'NETWORK',
    ),
    CatalogProduct(
      id: '3',
      name: 'Network Gateway V2',
      imageUrl: 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?w=500&auto=format',
      stock: 30,
      price: 4200.0,
      category: 'NETWORK',
    ),
    CatalogProduct(
      id: '4',
      name: 'Firewall Security Suite',
      imageUrl: 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=500&auto=format',
      stock: 30,
      price: 4200.0,
      category: 'LICENSES',
    ),
    CatalogProduct(
      id: '5',
      name: 'Compact Server Rack',
      imageUrl: 'https://images.unsplash.com/photo-1558494949-ef8b565b1d40?w=500&auto=format',
      stock: 12,
      price: 18500.0,
      category: 'HARDWARE',
    ),
    CatalogProduct(
      id: '6',
      name: 'Cloud OS Lifetime License',
      imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=500&auto=format',
      stock: 50,
      price: 12000.0,
      category: 'SOFTWARE',
    ),
    CatalogProduct(
      id: '7',
      name: 'Fiber Optic Patch Cable',
      imageUrl: 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=500&auto=format',
      stock: 150,
      price: 450.0,
      category: 'NETWORK',
    ),
  ];

  List<CatalogProduct> get _filteredProducts {
    if (_selectedCategory == 'ALL') return _products;
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  int get _totalItems => _products.where((p) => p.isAdded).length;
  int get _totalQty => _products
      .where((p) => p.isAdded)
      .fold(0, (sum, p) => sum + p.selectedQty);
  double get _totalAmount => _products
      .where((p) => p.isAdded)
      .fold(0, (sum, p) => sum + (p.price * p.selectedQty));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          widget.isReadOnly ? 'Inventory' : 'Sales Orders',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
        actions: [
          if (!widget.isReadOnly)
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
              tooltip: 'New Order',
              onPressed: () {},
            ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // White Header Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade500),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: widget.isReadOnly ? 'Search products...' : 'Search inventory catalog...',
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(Icons.qr_code_scanner, color: Colors.blue.shade600),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Categories
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = category),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : const Color(0xFFB2DFDB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF00695C),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // List Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Products',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Showing ${_filteredProducts.length} items',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),

          // Product List (Restoring original list view for Sales Orders)
          Expanded(
            child: widget.isReadOnly
                ? GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.64,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return _buildProductCard(product);
              },
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return _buildProductListItem(product);
              },
            ),
          ),

          // Persistent Bottom Panel
          if (!widget.isReadOnly && _totalItems > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Item : $_totalItems',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Qty : $_totalQty',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Amount : ${_totalAmount.toInt()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InvoiceScreen(
                              totalAmount: _totalAmount,
                              selectedProducts: _products.where((p) => p.isAdded).toList(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(CatalogProduct product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                // Stock Badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${product.stock} left',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A4A4A),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '₹${(product.price * 1.2).toInt()}',
                        style: TextStyle(
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'FREE Delivery',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductListItem(CatalogProduct product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        color: Color(0xFF1E242B),
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${product.stock} IN STOCK',
                      style: const TextStyle(
                        color: Color(0xFFB14D00),
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '₹${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFF1058B8),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Counter
              Container(
                width: 130,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EDF2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        if (product.selectedQty > 1) {
                          setState(() => product.selectedQty--);
                        }
                      },
                      child: const SizedBox(
                        width: 40,
                        height: 42,
                        child: Center(
                          child: Text(
                            '–',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '${product.selectedQty}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (product.selectedQty < product.stock) {
                          setState(() => product.selectedQty++);
                        }
                      },
                      child: const SizedBox(
                        width: 40,
                        height: 42,
                        child: Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    product.isAdded = !product.isAdded;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: product.isAdded
                      ? Colors.redAccent
                      : primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(82, 40),
                ),
                child: Text(
                  product.isAdded ? 'Remove' : 'Add',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}