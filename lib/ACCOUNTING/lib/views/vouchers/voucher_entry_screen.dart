import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VoucherEntryScreen extends StatefulWidget {
  final String voucherType;
  const VoucherEntryScreen({super.key, required this.voucherType});

  @override
  State<VoucherEntryScreen> createState() => _VoucherEntryScreenState();
}

class VoucherEntryRow {
  String type = 'SELECT';
  String ledgerCode = '';
  String ledgerName = '';
  double amount = 0.0;
  String referenceNo = '';
  String referenceDate = '04-04-2026';
  String narration = '';

  VoucherEntryRow();
}

class _VoucherEntryScreenState extends State<VoucherEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _docNoController = TextEditingController();
  final _dateController = TextEditingController(text: '04-04-2026');
  String _selectedPayAccount = 'Select Account';
  
  final List<VoucherEntryRow> _rows = [VoucherEntryRow()];

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF26A69A);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "New ${widget.voucherType}",
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveVoucher,
            child: Text(
              "SAVE",
              style: GoogleFonts.outfit(
                color: tealColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ENTRY DETAILS",
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      letterSpacing: 1,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addRow,
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    label: const Text("ADD ROW", style: TextStyle(color: Colors.white, fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._rows.asMap().entries.map((entry) => _buildEntryRow(entry.key, entry.value)),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveVoucher,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0061E0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "Save Changes",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E6ED)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildInputLabel("Voucher Entry Type"),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE0E6ED)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: "Type 1760",
                      isExpanded: true,
                      style: GoogleFonts.outfit(fontSize: 14, color: Colors.black87),
                      onChanged: (v) {},
                      items: ["Type 1760", "Type 1761"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPremiumField("Document No", "Enter No", controller: _docNoController),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPremiumField("Document Date", "04-04-2026", controller: _dateController),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPremiumDropdown("Pay Account", _selectedPayAccount, ["Select Account", "Cash Account", "Bank Account"], (v) {
            setState(() => _selectedPayAccount = v!);
          }),
        ],
      ),
    );
  }

  Widget _buildEntryRow(int index, VoucherEntryRow row) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E6ED)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey[200],
                child: Text("${index + 1}", style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ),
              if (_rows.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  onPressed: () => _removeRow(index),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildPremiumDropdown("TYPE", row.type, ["SELECT", "DEBIT", "CREDIT"], (v) => setState(() => row.type = v!))),
              const SizedBox(width: 12),
              Expanded(child: _buildPremiumField("LEDGER CODE", "Code", onChanged: (v) => row.ledgerCode = v)),
            ],
          ),
          const SizedBox(height: 12),
          _buildPremiumField("LEDGER NAME", "Enter Ledger Name", onChanged: (v) => row.ledgerName = v),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildPremiumField("AMOUNT", "0.00", keyboardType: TextInputType.number, onChanged: (v) => row.amount = double.tryParse(v) ?? 0)),
              const SizedBox(width: 12),
              Expanded(child: _buildPremiumField("REF NO", "Reference No", onChanged: (v) => row.referenceNo = v)),
            ],
          ),
          const SizedBox(height: 12),
          _buildPremiumField("NARRATION", "Enter Narration", maxLines: 2, onChanged: (v) => row.narration = v),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildPremiumField(String label, String hint, {TextEditingController? controller, int maxLines = 1, TextInputType? keyboardType, Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: GoogleFonts.outfit(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE0E6ED))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE0E6ED))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF26A69A))),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel(label),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E6ED)),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: GoogleFonts.outfit(fontSize: 14, color: Colors.black87),
              onChanged: onChanged,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _addRow() {
    setState(() {
      _rows.add(VoucherEntryRow());
    });
  }

  void _removeRow(int index) {
    setState(() {
      _rows.removeAt(index);
    });
  }

  void _saveVoucher() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Voucher Saved Successfully!"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }
}
