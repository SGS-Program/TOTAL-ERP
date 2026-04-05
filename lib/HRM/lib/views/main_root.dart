import 'package:flutter/material.dart';
import 'package:hrm/views/chat/chat.dart';
import 'attendance_history/attendance.dart';
import 'home/payroll.dart';
import 'home_screen/dashboard.dart';

class MainRoot extends StatefulWidget {
  final bool isEmbedded;
  const MainRoot({super.key, this.isEmbedded = false});

  @override
  State<MainRoot> createState() => _MainRootState();
}

class _MainRootState extends State<MainRoot> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    "HRM Dashboard",
    "Attendance",
    "Payroll Management",
    "Chat & Projects",
  ];

  final List<Widget> _screens = [
    const Dashboard(),
    const AttendanceScreen(),
    const PayrollScreen(),
    const ChatProjectsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF26A69A);
    assert(_screens.length == 4);
    
    return Scaffold(
      appBar: widget.isEmbedded ? null : AppBar(
        backgroundColor: tealColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: tealColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Payroll'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }
}
