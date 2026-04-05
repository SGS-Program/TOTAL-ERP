import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBottomNav extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? rawMobile = prefs.getString('mobile');
    String? mobile = rawMobile?.replaceAll(RegExp(r'\D'), '');
    if (mobile != null && mobile.length > 10) {
      mobile = mobile.substring(mobile.length - 10);
    }
    setState(() {
      currentUserId = mobile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF26A69A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              _buildNavItem(
                index: 0,
                iconPath: "assets/icons/home.png",
                label: "Home",
                screenWidth: screenWidth,
              ),
              _buildNavItem(
                index: 1,
                iconPath: "assets/icons/attendance.png",
                label: "Attendance",
                screenWidth: screenWidth,
              ),
              _buildNavItem(
                index: 2,
                iconPath: "assets/icons/payroll.png",
                label: "Payroll",
                screenWidth: screenWidth,
              ),
              _buildNavItem(
                index: 3,
                iconPath: "assets/icons/chat.png",
                label: "Chat",
                isChat: true,
                screenWidth: screenWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
    bool isChat = false,
    required double screenWidth,
  }) {
    final isSelected = widget.selectedIndex == index;
    final color = isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5);

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                   SizedBox(
                    height: screenWidth * 0.06,
                    width: screenWidth * 0.06,
                    child: Image.asset(iconPath, color: color),
                  ),
                  if (isChat && currentUserId != null)
                    Positioned(
                      top: -4,
                      right: -8,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chat_groups')
                            .where('members_list', arrayContains: currentUserId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox.shrink();

                          int unreadCount = 0;
                          for (var doc in snapshot.data!.docs) {
                            final data = doc.data() as Map<String, dynamic>;
                            final count = data['unread_$currentUserId'] ?? 0;
                            if (count is int) {
                              unreadCount += count;
                            }
                          }

                          if (unreadCount == 0) return const SizedBox.shrink();

                          return Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
