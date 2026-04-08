import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '/Proforma_Invoice_Module/payment_screen.dart';
export '/Proforma_Invoice_Module/product_model.dart';
import '/Proforma_Invoice_Module/product_model.dart';

class InvoiceCatalogScreen extends StatefulWidget {
  const InvoiceCatalogScreen({super.key});

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
      name: 'Enterprise Cloud\nServer - Rack A1',
      stock: 30,
      price: 4200.0,
      category: 'HARDWARE',
    ),
    CatalogProduct(
      id: '2',
      name: 'L2 Managed Switch\n- 48 Port',
      stock: 30,
      price: 4200.0,
      category: 'NETWORK',
    ),
    CatalogProduct(
      id: '3',
      name: 'L2 Managed Switch\n- 48 Port',
      stock: 30,
      price: 4200.0,
      category: 'NETWORK',
    ),
    CatalogProduct(
      id: '4',
      name: 'L2 Managed Switch\n- 48 Port',
      stock: 30,
      price: 4200.0,
      category: 'NETWORK',
    ),
    CatalogProduct(
      id: '5',
      name: 'L2 Managed Switch\n- 48 Port',
      stock: 30,
      price: 4200.0,
      category: 'NETWORK',
    ),
    CatalogProduct(
      id: '6',
      name: 'Server OS License\n- Lifetime',
      stock: 50,
      price: 4200.0,
      category: 'SOFTWARE',
    ),
    CatalogProduct(
      id: '7',
      name: 'L2 Managed Switch\n- 48 Port',
      stock: 30,
      price: 4200.0,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Invoice',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
                            hintText: 'Search inventory catalog...',
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
                  'Avaliable Products',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Showing ${_filteredProducts.length} items',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),

          // Product List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
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
              },
            ),
          ),

          // Persistent Bottom Panel
          if (_totalItems > 0)
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
                    ),                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}