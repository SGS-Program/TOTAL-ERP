import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purchase_erp/utils/device_services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CreatePurchaseOrderScreen extends StatefulWidget {
  const CreatePurchaseOrderScreen({super.key});

  @override
  State<CreatePurchaseOrderScreen> createState() =>
      _CreatePurchaseOrderScreenState();
}

class _CreatePurchaseOrderScreenState extends State<CreatePurchaseOrderScreen> {
  final List<Map<String, dynamic>> items = [
    {
      "code": TextEditingController(),
      "name": TextEditingController(),
      "uom": TextEditingController(),
      "qty": TextEditingController(text: "1"),
      "rate": TextEditingController(text: "0"),
      "taxPerc": TextEditingController(text: "0"),
      "taxAmt": TextEditingController(text: "0"),
      "discountPerc": TextEditingController(text: "0"),
      "discountAmt": TextEditingController(text: "0"),
      "total": TextEditingController(text: "0"),
    },
  ];

  final TextEditingController poNumberController = TextEditingController(
    text: "Auto-Generated",
  );
  final TextEditingController supplierNameController = TextEditingController();
  final TextEditingController deliveryAddressController =
      TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController(
    text:
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
  );

  String? cid;
  String? deviceId;
  bool isLoadingPoNumber = true;
  bool isSaving = false;
  String selectedStatus = "Pending";

  String grandTotal = "₹0.00";

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    Future.delayed(const Duration(milliseconds: 500), _calculateAll);
  }

  Future<void> _loadInitialData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String prefCid = prefs.getString('cid') ?? '';
      String prefDeviceId = prefs.getString('device_id') ?? 'Unknown';

      if (!mounted) return;
      setState(() {
        cid = prefCid;
        deviceId = prefDeviceId;
      });

      if (prefCid.isNotEmpty) {
        _fetchPONumber();
      } else {
        setState(() => isLoadingPoNumber = false);
      }

      if (prefDeviceId == 'Unknown') {
        DeviceServices.getStableDeviceId(prefs).then((id) {
          if (mounted) {
            setState(() => deviceId = id);
            if (cid != null && cid!.isNotEmpty) _fetchPONumber();
          }
        });
      }
    } catch (e) {
      debugPrint("Error loading initial data: $e");
      if (mounted) setState(() => isLoadingPoNumber = false);
    }
  }

  Future<void> _fetchPONumber() async {
    if (cid == null || cid!.isEmpty) {
      setState(() => isLoadingPoNumber = false);
      return;
    }

    setState(() => isLoadingPoNumber = true);

    try {
      final response = await http.post(
        Uri.parse("https://erpsmart.in/total/api/m_api/"),
        body: {
          "cid": cid!,
          "type": "4007",
          "ln": "22",
          "lt": "22",
          "device_id": deviceId ?? "Unknown",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if ((data['error'] == false || data['error'] == 'false')) {
          if (!mounted) return;
          setState(() {
            poNumberController.text = data['po_number']?.toString() ?? 'Auto-Generated';
          });
        }
      }
    } catch (e) {
      debugPrint("Failed to fetch PO Number: $e");
    } finally {
      if (mounted) setState(() => isLoadingPoNumber = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff26A69A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        deliveryDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _calculateAll() async {
    if (cid == null || cid!.isEmpty) return;

    try {
      double totalGrand = 0.0;

      for (var item in items) {
        final qty =
            double.tryParse((item["qty"] as TextEditingController).text) ?? 0;
        final rate =
            double.tryParse((item["rate"] as TextEditingController).text) ?? 0;
        final tax =
            double.tryParse((item["taxPerc"] as TextEditingController).text) ??
            0;
        final discount =
            double.tryParse(
              (item["discountPerc"] as TextEditingController).text,
            ) ??
            0;

        if (qty == 0 || rate == 0) {
          (item["total"] as TextEditingController).text = "0";
          continue;
        }

        final response = await http
            .post(
              Uri.parse("https://erpsmart.in/total/api/m_api/"),
              body: {
                "type": "4008",
                "cid": cid!,
                "device_id": deviceId ?? "342",
                "ln": "22",
                "lt": "22",
                "quantity": qty.toString(),
                "unit_rate": rate.toString(),
                "discount": discount.toString(),
                "tax": tax.toString(),
              },
            )
            .timeout(const Duration(seconds: 8));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['success'] == true &&
              data['items'] != null &&
              data['items'].isNotEmpty) {
            final calc = data['items'][0];

            setState(() {
              (item["discountAmt"] as TextEditingController).text =
                  (calc['discount_amount'] ?? "0").toString();
              (item["taxAmt"] as TextEditingController).text =
                  (calc['tax_amt'] ?? "0").toString();
              (item["total"] as TextEditingController).text =
                  (calc['tot_amt'] ?? "0").toString();

              totalGrand +=
                  double.tryParse(calc['tot_amt']?.toString() ?? "0") ?? 0;
            });
          }
        }
      }

      setState(() {
        grandTotal = "₹${totalGrand.toStringAsFixed(2)}";
      });
    } catch (e) {
      debugPrint("Calculation API Error: $e");
    }
  }

  Future<List<Map<String, dynamic>>> _searchSuppliers(String query) async {
    if (cid == null || cid!.isEmpty || query.isEmpty) return [];

    try {
      final response = await http.post(
        Uri.parse("https://erpsmart.in/total/api/m_api/"),
        body: {
          "type": "4010",
          "cid": cid!,
          "device_id": deviceId ?? "123",
          "lt": "22",
          "ln": "22",
          "search": query,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
    } catch (e) {
      debugPrint("Search Suppliers Error: $e");
    }
    return [];
  }

  void _onValueChanged() {
    _calculateAll();
  }

  Future<void> _savePurchaseOrder() async {
    if (cid == null || cid!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Company ID not found")));
      return;
    }

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one item")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      List<Map<String, dynamic>> itemList = items.map((item) {
        return {
          "item_code": (item["code"] as TextEditingController).text.trim(),
          "pro_name": (item["name"] as TextEditingController).text.trim(),
          "uom": (item["uom"] as TextEditingController).text.trim(),
          "quantity": (item["qty"] as TextEditingController).text.trim(),
          "unit_rate": (item["rate"] as TextEditingController).text.trim(),
          "discount": (item["discountPerc"] as TextEditingController).text
              .trim(),
          "tax": (item["taxPerc"] as TextEditingController).text.trim(),
          "tax_amount": (item["taxAmt"] as TextEditingController).text.trim(),
          "tot-amt": (item["total"] as TextEditingController).text.trim(),
        };
      }).toList();

      final Map<String, String> body = {
        "cid": cid!,
        "type": "4009",
        "ln": "22",
        "lt": "22",
        "device_id": deviceId ?? "342",
        "po_no": poNumberController.text == "Auto-Generated"
            ? ""
            : poNumberController.text,
        "delivery_date": deliveryDateController.text,
        "status": selectedStatus,
        "supplier_name": supplierNameController.text.trim(),
        "tax": itemList.isNotEmpty ? itemList[0]['tax'].toString() : "0",
        "discount": itemList.isNotEmpty
            ? itemList[0]['discount'].toString()
            : "0",
        "tax_amount": itemList.isNotEmpty
            ? itemList[0]['tax_amount'].toString()
            : "0",
        "unit_rate": itemList.isNotEmpty
            ? itemList[0]['unit_rate'].toString()
            : "0",
        "quantity": itemList.isNotEmpty
            ? itemList[0]['quantity'].toString()
            : "0",
        "item_code": itemList.isNotEmpty
            ? itemList[0]['item_code'].toString()
            : "",
        "pro_name": itemList.isNotEmpty
            ? itemList[0]['pro_name'].toString()
            : "",
        "grand_total": grandTotal
            .replaceAll('₹', '')
            .replaceAll(',', '')
            .trim(),
        "items": jsonEncode(itemList),
      };

      debugPrint("🚀 SUBMITTING PO BODY: $body");

      final response = await http.post(
        Uri.parse("https://erpsmart.in/total/api/m_api/"),
        body: body,
      );

      debugPrint("📤 SAVE REQUEST BODY: ${response.request?.url}");
      debugPrint("📥 SAVE RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['error'] == false || data['error'] == 'false') {
          if (!mounted) return;
          _showSuccessDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? "Failed to save purchase order"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error. Please try again.")),
        );
      }
    } catch (e) {
      debugPrint("❌ Save Purchase Order Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: const Color(0xff26A69A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create Purchase Order",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // All your existing fields (PO No, Delivery Date, Status, Supplier, etc.) remain unchanged
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [buildLabel("PO No")],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: poNumberController,
                      readOnly: true,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: "Fetching PO Number...",
                      ),
                    ),
                  ),
                  if (isLoadingPoNumber)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            buildLabel("Delivery Date"),
            InkWell(
              onTap: () => _selectDate(context),
              child: IgnorePointer(
                child: TextField(
                  controller: deliveryDateController,
                  decoration: InputDecoration(
                    hintText: "YYYY-MM-DD",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff26A69A)),
                    ),
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xff26A69A),
                      size: 18,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            buildLabel("Status"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedStatus,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  items: ["Pending", "Approved", "Rejected"].map((value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) =>
                      setState(() => selectedStatus = newValue!),
                ),
              ),
            ),
            const SizedBox(height: 16),

            buildLabel("Supplier Name"),
            TypeAheadField<Map<String, dynamic>>(
              controller: supplierNameController,
              suggestionsCallback: _searchSuppliers,
              builder: (context, controller, focusNode) => TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: "Enter supplier name",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff26A69A)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              itemBuilder: (context, suggestion) => ListTile(
                title: Text(suggestion['Ledger_Name'] ?? 'N/A'),
                subtitle: Text(suggestion['address'] ?? ''),
              ),
              emptyBuilder: (context) => const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Search for Supplier...",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              onSelected: (suggestion) {
                setState(() {
                  supplierNameController.text = suggestion['Ledger_Name'] ?? '';
                  deliveryAddressController.text = suggestion['address'] ?? '';
                });
              },
            ),
            const SizedBox(height: 16),

            buildLabel("Quotation Reference"),
            buildTextField("Enter Quotation Reference"),
            const SizedBox(height: 16),

            buildLabel("Delivery Address"),
            TextField(
              controller: deliveryAddressController,
              decoration: InputDecoration(
                hintText: "Enter delivery address",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff26A69A)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            buildLabel("Payment Terms"),
            buildTextField("Select Payment Terms"),
            const SizedBox(height: 22),

            // Items Section (Unchanged)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Items",
                        style: TextStyle(
                          color: Color(0xff512DA8),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            items.add({
                              "code": TextEditingController(),
                              "name": TextEditingController(),
                              "uom": TextEditingController(),
                              "qty": TextEditingController(text: "1"),
                              "rate": TextEditingController(text: "0"),
                              "taxPerc": TextEditingController(text: "0"),
                              "taxAmt": TextEditingController(text: "0"),
                              "discountPerc": TextEditingController(text: "0"),
                              "discountAmt": TextEditingController(text: "0"),
                              "total": TextEditingController(text: "0"),
                            });
                          });
                          _calculateAll();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff26A69A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.add, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                "Add Item",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: List.generate(
                      items.length,
                      (index) => buildItemCard(index),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grand Total
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xffE0F2F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Grand Total",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    grandTotal,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff00695C),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Button with Loading
            InkWell(
              onTap: isSaving ? null : _savePurchaseOrder,
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSaving ? Colors.grey : const Color(0xff26A69A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Confirm Purchase Order",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ==================== buildItemCard & All other helper methods remain EXACTLY SAME ====================
  // (I'm not repeating them here to save space — they are unchanged)

  Widget buildItemCard(int index) {
    final item = items[index];

    void addListener(TextEditingController ctrl) {
      ctrl.removeListener(_onValueChanged);
      ctrl.addListener(_onValueChanged);
    }

    addListener(item["qty"] as TextEditingController);
    addListener(item["rate"] as TextEditingController);
    addListener(item["taxPerc"] as TextEditingController);
    addListener(item["discountPerc"] as TextEditingController);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Item ${index + 1}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (items.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () {
                    setState(() => items.removeAt(index));
                    _calculateAll();
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),

          buildItemLabel("Item Code"),
          TypeAheadField<Map<String, dynamic>>(
            controller: item["code"] as TextEditingController,
            suggestionsCallback: _searchItems,
            debounceDuration: const Duration(milliseconds: 300),
            builder: (context, controller, focusNode) => TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Enter Item Code",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff26A69A)),
                ),
              ),
            ),
            itemBuilder: (context, suggestion) => ListTile(
              title: Text(suggestion['Item Code'] ?? 'N/A'),
              subtitle: Text(suggestion['Item name'] ?? ''),
            ),
            emptyBuilder: (context) => const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Search for Item Code...",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            onSelected: (suggestion) {
              setState(() {
                (item["code"] as TextEditingController).text =
                    suggestion['Item Code'] ?? '';
                (item["name"] as TextEditingController).text =
                    suggestion['Item name'] ?? '';
                (item["uom"] as TextEditingController).text =
                    suggestion['UOM'] ?? '';
              });
              _calculateAll();
            },
          ),

          const SizedBox(height: 12),
          buildItemLabel("Item Name"),
          TypeAheadField<Map<String, dynamic>>(
            controller: item["name"] as TextEditingController,
            suggestionsCallback: _searchItems,
            builder: (context, controller, focusNode) => TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Enter Item Name",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff26A69A)),
                ),
              ),
            ),
            itemBuilder: (context, suggestion) => ListTile(
              title: Text(suggestion['Item name'] ?? ''),
              subtitle: Text("Code: ${suggestion['Item Code'] ?? ''}"),
            ),
            emptyBuilder: (context) => const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Search for Item Name...",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            onSelected: (suggestion) {
              setState(() {
                (item["code"] as TextEditingController).text =
                    suggestion['Item Code'] ?? '';
                (item["name"] as TextEditingController).text =
                    suggestion['Item name'] ?? '';
                (item["uom"] as TextEditingController).text =
                    suggestion['UOM'] ?? '';
              });
              _calculateAll();
            },
          ),

          const SizedBox(height: 12),
          buildItemLabel("UOM"),
          buildItemTextField("UOM", item["uom"] as TextEditingController),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildItemLabel("QTY"),
                    buildItemTextField(
                      "0",
                      item["qty"] as TextEditingController,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildItemLabel("Unit Rate"),
                    buildItemTextField(
                      "0",
                      item["rate"] as TextEditingController,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildItemLabel("Discount %"),
                    buildItemTextField(
                      "0",
                      item["discountPerc"] as TextEditingController,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildItemLabel("Discount Amount"),
                    buildItemTextField(
                      "0.00",
                      item["discountAmt"] as TextEditingController,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildItemLabel("Tax %"),
                    buildItemTextField(
                      "0",
                      item["taxPerc"] as TextEditingController,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildItemLabel("Tax Amount"),
                    buildItemTextField(
                      "0.00",
                      item["taxAmt"] as TextEditingController,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          buildItemLabel("Total Amount"),
          buildItemTextField(
            "0.00",
            item["total"] as TextEditingController,
            readOnly: true,
          ),
        ],
      ),
    );
  }

  // All your existing helper widgets (buildLabel, buildItemLabel, buildTextField, buildItemTextField, _searchItems, _showSuccessDialog, dispose) remain **unchanged**

  Widget buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    ),
  );

  Widget buildItemLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.black87,
      ),
    ),
  );

  Widget buildTextField(String hint) => TextField(
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff26A69A)),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
  );

  Widget buildItemTextField(
    String hint,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff26A69A)),
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _searchItems(String query) async {
    if (query.trim().isEmpty || cid == null) return [];
    try {
      final response = await http.post(
        Uri.parse("https://erpsmart.in/total/api/m_api/"),
        body: {
          "type": "4003",
          "cid": cid!,
          "device_id": deviceId ?? "123",
          "lt": "123",
          "ln": "987",
          "search": query.trim(),
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
    } catch (e) {
      debugPrint("Search error: $e");
    }
    return [];
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xff26A69A), size: 60),
            const SizedBox(height: 16),
            const Text(
              "Success!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Purchase Order created successfully",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff26A69A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    poNumberController.dispose();
    supplierNameController.dispose();
    deliveryAddressController.dispose();
    deliveryDateController.dispose();
    for (var item in items) {
      item.values.whereType<TextEditingController>().forEach(
        (c) => c.dispose(),
      );
    }
    super.dispose();
  }
}
