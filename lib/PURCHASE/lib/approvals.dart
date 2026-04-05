import 'package:flutter/material.dart';
import 'package:purchase_erp/dashboard.dart';
import 'widgets/bottom_nav.dart';

class PendingApprovals extends StatelessWidget {
  const PendingApprovals({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],

        /// APP BAR
        appBar: AppBar(
          elevation: 0,
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            },
          ),
          title: const Text(
            "Pending Approvals",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),

        /// BODY
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.02,
          ),
          child: Column(
            children: [
              /// STATUS CARDS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statCard(
                    width,
                    "Total Pending",
                    "3",
                    const Color(0xffA29329),
                    Icons.description_outlined,
                  ),
                  statCard(
                    width,
                    "High Priority",
                    "1",
                    const Color(0xff0F6229),
                    Icons.trending_up,
                  ),
                  statCard(
                    width,
                    "Total Value",
                    "₹3,65,000",
                    const Color(0xff1B607E),
                    Icons.assignment_outlined,
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),

              /// LIST OF APPROVALS
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: const [
                    ApprovalCard(
                      prNumber: "PR102",
                      amount: "₹15,000",
                      title: "Office Supplies Request",
                      department: "Administration",
                      requestedBy: "John Doe",
                    ),
                    SizedBox(height: 16),
                    ApprovalCard(
                      prNumber: "PR103",
                      amount: "₹85,000",
                      title: "IT Equipment Purchase",
                      department: "IT Department",
                      requestedBy: "John Smith",
                    ),
                    SizedBox(height: 16),
                    ApprovalCard(
                      prNumber: "PR104",
                      amount: "₹25,000",
                      title: "Marketing Materials",
                      department: "Marketing",
                      requestedBy: "Mike Johnson",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// BOTTOM NAV
        bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 2),
      ),
    );
  }

  /// STAT CARD WIDGET
  Widget statCard(
    double width,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: width * 0.29,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ApprovalCard extends StatelessWidget {
  final String prNumber;
  final String amount;
  final String title;
  final String department;
  final String requestedBy;

  const ApprovalCard({
    super.key,
    required this.prNumber,
    required this.amount,
    required this.title,
    required this.department,
    required this.requestedBy,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// PR + AMOUNT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                prNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  color: Color(0xFF26A69A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// TITLE
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            department,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 12),

          Text(
            "Request By : $requestedBy",
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 18),

          /// BUTTONS
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Approved Successfully!"),
                        backgroundColor: Color(0xff24A507),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xff24A507),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle_outline,
                            color: Colors.white, size: 22),
                        SizedBox(width: 8),
                        Text(
                          "Approve",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Rejected Successfully!"),
                        backgroundColor: Color(0xffDA0909),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xffDA0909),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cancel_outlined,
                            color: Colors.white, size: 22),
                        SizedBox(width: 8),
                        Text(
                          "Reject",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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

