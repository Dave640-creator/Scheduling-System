// lib/pages/instructor_dashboard.dart
import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../models/app_state.dart';
import '../theme.dart';
import '../widgets/tcgc_logo.dart';
import 'login_page.dart';

class InstructorDashboard extends StatelessWidget {
  final AppUser user;
  const InstructorDashboard({super.key, required this.user});

  static const _mySchedules = [
    {'subject': 'Data Structures', 'room': 'Room 301', 'day': 'Monday', 'time': '8:00 AM - 10:00 AM', 'students': 35},
    {'subject': 'Database Systems', 'room': 'Room 303', 'day': 'Monday', 'time': '8:00 AM - 10:00 AM', 'students': 30},
    {'subject': 'Algorithms', 'room': 'Room 304', 'day': 'Wednesday', 'time': '2:00 PM - 4:00 PM', 'students': 32},
  ];
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGray50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          const TcgcLogoSmall(size: 38),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('TCGC - Instructor Portal', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900)),
            Text(user.name, style: const TextStyle(fontSize: 11, color: kGray500)),
          ]),
        ]),
        actions: [TextButton.icon(
          onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false),
          icon: const Icon(Icons.logout, color: kGray700, size: 18),
          label: const Text('Logout', style: TextStyle(color: kGray700, fontSize: 13)))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Instructor Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
          const Text('View your teaching schedule and assignments', style: TextStyle(fontSize: 13, color: kGray500)),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (ctx, c) => GridView.count(
            crossAxisCount: c.maxWidth > 500 ? 3 : 1, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 2.5,
            children: [
              _statCard('Assigned Subjects', '${_mySchedules.length}', Icons.book_outlined, kGreen),
              _statCard('Teaching Days', '2', Icons.calendar_month_outlined, kBlue),
              _statCard('Total Students', '97', Icons.school_outlined, const Color(0xFF7C3AED)),
            ],
          )),
          const SizedBox(height: 20),
          Container(decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
            child: Column(children: [
              const Padding(padding: EdgeInsets.all(16), child: Align(alignment: Alignment.centerLeft, child: Text('Weekly Schedule', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kGray900)))),
              const Divider(height: 1, color: kGray200),
              Padding(padding: const EdgeInsets.all(16), child: Column(children: _days.map((day) {
                final classes = _mySchedules.where((s) => s['day'] == day).toList();
                return Container(margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(border: Border.all(color: kGray200), borderRadius: BorderRadius.circular(8)),
                  child: Column(children: [
                    Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: const BoxDecoration(color: kGray50, borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7))),
                      child: Text(day, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray700))),
                    Padding(padding: const EdgeInsets.all(12), child: classes.isEmpty
                      ? const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('No classes scheduled', style: TextStyle(fontSize: 13, color: kGray400))))
                      : Column(children: classes.map((c) => Container(
                        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: kGreenBg, border: Border.all(color: const Color(0xFFBBF7D0)), borderRadius: BorderRadius.circular(6)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(c['subject'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900)),
                            Text(c['room'] as String, style: const TextStyle(fontSize: 12, color: kGray500)),
                          ]),
                          Text(c['time'] as String, style: const TextStyle(fontSize: 12, color: kGray500)),
                        ]))).toList())),
                  ]));
              }).toList())),
            ])),
          const SizedBox(height: 20),
          Container(decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
            child: Column(children: [
              const Padding(padding: EdgeInsets.all(16), child: Align(alignment: Alignment.centerLeft, child: Text('My Subjects', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kGray900)))),
              const Divider(height: 1, color: kGray200),
              SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
                headingRowColor: WidgetStateProperty.all(kGray50),
                columns: ['Subject', 'Room', 'Day', 'Time', 'Students'].map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
                rows: _mySchedules.map((s) => DataRow(cells: [
                  DataCell(Text(s['subject'] as String, style: const TextStyle(fontSize: 13, color: kGray900))),
                  DataCell(Text(s['room'] as String, style: const TextStyle(fontSize: 13, color: kGray500))),
                  DataCell(Text(s['day'] as String, style: const TextStyle(fontSize: 13, color: kGray500))),
                  DataCell(Text(s['time'] as String, style: const TextStyle(fontSize: 13, color: kGray500))),
                  DataCell(Text('${s['students']}', style: const TextStyle(fontSize: 13, color: kGray900))),
                ])).toList(),
              )),
            ])),
        ]),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    padding: const EdgeInsets.all(14),
    child: Row(children: [
      Container(width: 42, height: 42, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: kWhite, size: 20)),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
        Text(label, style: const TextStyle(fontSize: 11, color: kGray500)),
      ]),
    ]),
  );
}
