import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/tcgc_logo.dart';
import '../login_page.dart';
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
  int _sel = 0;

  static const _items = [
    {'label': 'Dashboard',        'icon': Icons.grid_view_rounded},
    {'label': 'Schedules',        'icon': Icons.calendar_month_outlined},
    {'label': 'Approve Accounts', 'icon': Icons.how_to_reg_outlined},
    {'label': 'Rooms',            'icon': Icons.meeting_room_outlined},
    {'label': 'Instructors',      'icon': Icons.people_outline},
    {'label': 'Students',         'icon': Icons.school_outlined},
    {'label': 'Announcements',    'icon': Icons.campaign_outlined},
    {'label': 'Reports',          'icon': Icons.bar_chart_outlined},
  ];

  static const _pages = [
    AdminDashboard(),
    AdminSchedules(),
    AdminApprove(),
    AdminRooms(),
    AdminInstructors(),
    AdminStudents(),
    AdminAnnouncements(),
    AdminReports(),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 600;
    final isTablet = w >= 600 && w < 900;
    // Mobile: bottom nav + drawer
    // Tablet: rail
    // Desktop: full sidebar

    if (isMobile) return _buildMobile();
    if (isTablet) return _buildTablet();
    return _buildDesktop();
  }

  // ── MOBILE ────────────────────────────────────────────────────────────────
  Widget _buildMobile() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        surfaceTintColor: kWhite,
        elevation: 0,
        title: Row(children: [
          const TcgcLogoSmall(size: 32), const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('TCGC Admin', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kGray900)),
            Text(_items[_sel]['label'] as String, style: const TextStyle(fontSize: 11, color: kGray500)),
          ]),
        ]),
        actions: [
          Builder(builder: (ctx) => IconButton(icon: const Icon(Icons.menu, color: kGray700), onPressed: () => Scaffold.of(ctx).openEndDrawer())),
        ],
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: kGray200, height: 1)),
      ),
      endDrawer: Drawer(child: _drawerContent()),
      body: IndexedStack(index: _sel, children: _pages),
    );
  }

  // ── TABLET ────────────────────────────────────────────────────────────────
  Widget _buildTablet() {
    return Scaffold(
      body: Row(children: [
        NavigationRail(
          backgroundColor: kWhite,
          selectedIndex: _sel,
          onDestinationSelected: (i) => setState(() => _sel = i),
          labelType: NavigationRailLabelType.all,
          selectedIconTheme: const IconThemeData(color: kGreen),
          selectedLabelTextStyle: const TextStyle(color: kGreen, fontSize: 10, fontWeight: FontWeight.w600),
          unselectedIconTheme: const IconThemeData(color: kGray500),
          unselectedLabelTextStyle: const TextStyle(color: kGray500, fontSize: 10),
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(children: [
              const TcgcLogoSmall(size: 36),
              const SizedBox(height: 4),
              const Text('Admin', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: kGray900)),
            ]),
          ),
          trailing: Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: kGray500, size: 20),
                  onPressed: _logout,
                  tooltip: 'Logout',
                ),
              ),
            ),
          ),
          destinations: _items.map((item) => NavigationRailDestination(
            icon: Icon(item['icon'] as IconData),
            label: Text(item['label'] as String),
          )).toList(),
        ),
        const VerticalDivider(width: 1, color: kGray200),
        Expanded(child: IndexedStack(index: _sel, children: _pages)),
      ]),
    );
  }

  // ── DESKTOP ───────────────────────────────────────────────────────────────
  Widget _buildDesktop() {
    return Scaffold(
      body: Row(children: [
        Container(
          width: 240,
          decoration: const BoxDecoration(color: kWhite, border: Border(right: BorderSide(color: kGray200))),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kGray200))),
              child: Row(children: [
                const TcgcLogoSmall(size: 40), const SizedBox(width: 10),
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('TCGC', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kGray900)),
                  Text('Admin Portal', style: TextStyle(fontSize: 11, color: kGray500)),
                ]),
              ]),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: _items.asMap().entries.map((e) => _navBtn(e.key, e.value)).toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: kGray200))),
              child: _navBtnRaw(Icons.logout, 'Logout', _logout, isActive: false),
            ),
          ]),
        ),
        Expanded(child: IndexedStack(index: _sel, children: _pages)),
      ]),
    );
  }

  Widget _drawerContent() => Column(children: [
    DrawerHeader(
      decoration: const BoxDecoration(color: kGreenBg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const TcgcLogoSmall(size: 44), const SizedBox(height: 8),
        const Text('TCGC', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kGray900)),
        const Text('Admin Portal', style: TextStyle(fontSize: 12, color: kGray500)),
      ]),
    ),
    Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: _items.asMap().entries.map((e) => ListTile(
          selected: _sel == e.key,
          selectedTileColor: kGreenBg,
          selectedColor: kGreen,
          iconColor: kGray500,
          leading: Icon(e.value['icon'] as IconData),
          title: Text(e.value['label'] as String, style: const TextStyle(fontSize: 13)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTap: () { setState(() => _sel = e.key); Navigator.pop(context); },
        )).toList(),
      ),
    ),
    const Divider(height: 1),
    ListTile(
      leading: const Icon(Icons.logout, color: kGray500),
      title: const Text('Logout', style: TextStyle(fontSize: 13, color: kGray700)),
      onTap: _logout,
    ),
  ]);

  Widget _navBtn(int idx, Map item) => _navBtnRaw(
    item['icon'] as IconData, item['label'] as String,
    () => setState(() => _sel = idx),
    isActive: _sel == idx,
  );

  Widget _navBtnRaw(IconData icon, String label, VoidCallback onTap, {required bool isActive}) =>
    InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: isActive ? kGreenBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [
          Icon(icon, size: 18, color: isActive ? kGreen : kGray500),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 13, color: isActive ? kGreen : kGray700, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
        ]),
      ),
    );

  void _logout() => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
}
