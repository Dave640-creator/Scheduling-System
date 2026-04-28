// lib/pages/admin/admin_shell.dart
import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/tcgc_logo.dart';
import '../../pages/login_page.dart';
import 'admin_dashboard.dart';
import 'admin_schedules.dart';
import 'admin_approve.dart';
import 'admin_rooms.dart';
import 'admin_instructors.dart';
import 'admin_students.dart';
import 'admin_announcements.dart';
import 'admin_reports.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> get _navItems => [
    {'label': 'Dashboard',        'icon': Icons.grid_view_rounded,         'page': const AdminDashboard()},
    {'label': 'Manage Schedules', 'icon': Icons.calendar_month_outlined,   'page': const AdminSchedules()},
    {'label': 'Approve Accounts', 'icon': Icons.how_to_reg_outlined,       'page': const AdminApprove()},
    {'label': 'Rooms',            'icon': Icons.meeting_room_outlined,     'page': const AdminRooms()},
    {'label': 'Instructors',      'icon': Icons.people_outline,            'page': const AdminInstructors()},
    {'label': 'Students',         'icon': Icons.school_outlined,           'page': const AdminStudents()},
    {'label': 'Announcements',    'icon': Icons.campaign_outlined,         'page': const AdminAnnouncements()},
    {'label': 'Reports',          'icon': Icons.bar_chart_outlined,        'page': const AdminReports()},
  ];

  @override
  Widget build(BuildContext context) {
    final items = _navItems;
    final isWide = MediaQuery.of(context).size.width > 768;
    return Scaffold(
      drawer: isWide ? null : _buildDrawer(items),
      body: Row(children: [
        if (isWide) _buildSidebar(items),
        Expanded(child: Column(children: [
          if (!isWide) _buildTopBar(),
          Expanded(child: items[_selectedIndex]['page'] as Widget),
        ])),
      ]),
    );
  }

  Widget _buildTopBar() => Container(
    decoration: const BoxDecoration(color: kWhite, border: Border(bottom: BorderSide(color: kGray200))),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(children: [
      Builder(builder: (ctx) => IconButton(icon: const Icon(Icons.menu, color: kGray700), onPressed: () => Scaffold.of(ctx).openDrawer())),
      const SizedBox(width: 8), const TcgcLogoSmall(size: 32), const SizedBox(width: 8),
      const Text('TCGC Admin', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kGray900)),
    ]),
  );

  Widget _buildSidebar(List<Map<String, dynamic>> items) => Container(
    width: 256,
    decoration: const BoxDecoration(color: kWhite, border: Border(right: BorderSide(color: kGray200))),
    child: Column(children: [
      Container(padding: const EdgeInsets.all(20), decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kGray200))),
        child: Row(children: [const TcgcLogoSmall(size: 44), const SizedBox(width: 12), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('TCGC', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900)), Text('Admin Portal', style: TextStyle(fontSize: 11, color: kGray500))])])),
      Expanded(child: ListView(padding: const EdgeInsets.all(12), children: items.asMap().entries.map((e) => _navButton(e.key, e.value)).toList())),
      Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(border: Border(top: BorderSide(color: kGray200))), child: _logoutButton()),
    ]),
  );

  Widget _buildDrawer(List<Map<String, dynamic>> items) => Drawer(child: _buildSidebar(items));

  Widget _navButton(int index, Map<String, dynamic> item) {
    final isActive = _selectedIndex == index;
    return Padding(padding: const EdgeInsets.only(bottom: 2), child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(color: isActive ? kGreenBg : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          Icon(item['icon'] as IconData, size: 18, color: isActive ? kGreen : kGray700),
          const SizedBox(width: 12),
          Text(item['label'] as String, style: TextStyle(fontSize: 13, color: isActive ? kGreen : kGray700, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
        ]),
      ),
    ));
  }

  Widget _logoutButton() => InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false),
    child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11), child: const Row(children: [Icon(Icons.logout, size: 18, color: kGray700), SizedBox(width: 12), Text('Logout', style: TextStyle(fontSize: 13, color: kGray700))])),
  );
}
