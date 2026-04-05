import 'package:flutter/material.dart';

class PODetailsScreen extends StatelessWidget {
  const PODetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF26A69A), Color(0xFF26A69A)],
            ),
          ),
        ),
        title: const Text(
          "Purchase Order Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: Column(
            children: [
              _buildPOAndContactCard(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildItemsCard(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildDeliveryInfoCard(screenWidth),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // Print PDF logic here
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text(
                  "Print PDF",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPOAndContactCard(double width) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PO001",
                    style: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "ABC Traders",
                    style: TextStyle(
                      fontSize: width * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff088C29),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Approve",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn("PO Date", "2026-03-10", width),
              _buildInfoColumn("Delivery Date", "2026-03-20", width),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn("PR Number", "PR002", width, isLink: true),
              _buildInfoColumn("RFQ Number", "RFQ001", width, isLink: true),
            ],
          ),
          const Divider(height: 40),
          Text(
            "Contact Information",
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn("Contact Person", "Rajesh Kumar", width),
              _buildInfoColumn("Phone", "+91 98765 4****", width),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsCard(double width) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Items",
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Marketing Materials",
            style: TextStyle(
              fontSize: width * 0.038,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Brouchures and Flyers",
                    style: TextStyle(
                      fontSize: width * 0.032,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Quantity:1000",
                    style: TextStyle(
                      fontSize: width * 0.032,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                "₹45",
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: TextStyle(
                  fontSize: width * 0.038,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "₹45,000",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff2E1A8B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfoCard(double width) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery Information",
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Delivery Address",
            style: TextStyle(fontSize: width * 0.032, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            "123 Business Park, Mumbai, Maharashtra-400001",
            style: TextStyle(fontSize: width * 0.035),
          ),
          const SizedBox(height: 16),
          Text(
            "Payment Terms",
            style: TextStyle(fontSize: width * 0.032, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            "Net 30 days",
            style: TextStyle(
              fontSize: width * 0.038,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(
    String label,
    String value,
    double width, {
    bool isLink = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: width * 0.032, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: width * 0.038,
            fontWeight: FontWeight.bold,
            color: isLink ? const Color(0xff2E1A8B) : Colors.black,
          ),
        ),
      ],
    );
  }
}
