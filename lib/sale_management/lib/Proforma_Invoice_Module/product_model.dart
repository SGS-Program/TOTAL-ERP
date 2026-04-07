
class CatalogProduct {
  final String id;
  final String name;
  final int stock;
  final double price;
  final String category;
  int selectedQty;
  bool isAdded;

  CatalogProduct({
    required this.id,
    required this.name,
    required this.stock,
    required this.price,
    required this.category,
    this.selectedQty = 1,
    this.isAdded = false,
  });
}
