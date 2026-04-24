// lib/pages/student_dashboard.dart
import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../models/app_state.dart';
import '../theme.dart';
import '../widgets/tcgc_logo.dart';
import 'login_page.dart';

class StudentDashboard extends StatelessWidget {
  final AppUser user;
  const StudentDashboard({super.key, required this.user});
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  Widget build(BuildContext context) {
    final schedule = AppState.studentSchedule;
    return Scaffold(
      backgroundColor: kGray50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          const TcgcLogoSmall(size: 38),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('TCGC - Student Portal', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900)),
            Text('${user.name} (${user.idNumber})', style: const TextStyle(fontSize: 11, color: kGray500)),
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
          const Text('Student Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
          const Text('View your class schedule and course information', style: TextStyle(fontSize: 13, color: kGray500)),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (ctx, c) {
            final cols = c.maxWidth > 500 ? 3 : 1;
            return GridView.count(
              crossAxisCount: cols, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: cols == 1 ? 3.5 : 2.3,
              children: [
                _statCard('Enrolled Subjects', '${schedule.length}', Icons.book_outlined, kGreen),
                _statCard('Class Days', '5', Icons.calendar_month_outlined, kBlue),
                _infoCard('BS Computer Science', '3rd Year', const Color(0xFF7C3AED)),
              ],
            );
          }),
          const SizedBox(height: 20),
          Container(decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
            child: Column(children: [
              const Padding(padding: EdgeInsets.all(16), child: Align(alignment: Alignment.centerLeft, child: Text('Weekly Class Schedule', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kGray900)))),
              const Divider(height: 1, color: kGray200),
              Padding(padding: const EdgeInsets.all(16), child: Column(children: _days.map((day) {
                final classes = schedule.where((s) => s['day'] == day).toList();
                return Container(margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(border: Border.all(color: kGray200), borderRadius: BorderRadius.circular(8)),
                  child: Column(children: [
                    Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: const BoxDecoration(color: kGray50, borderRadius: BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7))),
                      child: Text(day, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray700))),
                    Padding(padding: const EdgeInsets.all(12), child: classes.isEmpty
                      ? const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('No classes scheduled', style: TextStyle(fontSize: 13, color: kGray400))))
                      : Column(children: classes.map((c) => Container(
                        margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: kGreenBg, border: Border.all(color: const Color(0xFFBBF7D0)), borderRadius: BorderRadius.circular(8)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(c['subject']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900)),
                            const SizedBox(height: 2),
                            Text('Instructor: ${c['instructor']}', style: const TextStyle(fontSize: 12, color: kGray500)),
                            Text(c['room']!, style: const TextStyle(fontSize: 12, color: kGray500)),
                          ])),
                          Text(c['time']!, style: const TextStyle(fontSize: 12, color: kGray500)),
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
                columns: ['Subject', 'Instructor', 'Room', 'Day', 'Time'].map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
                rows: schedule.map((s) => DataRow(cells: [
                  DataCell(Text(s['subject']!, style: const TextStyle(fontSize: 13, color: kGray900))),
                  DataCell(Text(s['instructor']!, style: const TextStyle(fontSize: 13, color: kGray500))),
                  DataCell(Text(s['room']!, style: const TextStyle(fontSize: 13, color: kGray500))),
                  DataCell(Text(s['day']!, style: const TextStyle(fontSize: 13, color: kGray500))),
                  DataCell(Text(s['time']!, style: const TextStyle(fontSize: 13, color: kGray500))),
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

  Widget _infoCard(String program, String year, Color color) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    padding: const EdgeInsets.all(14),
    child: Row(children: [
      Container(width: 42, height: 42, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.school_outlined, color: kWhite, size: 20)),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(program, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900)),
        Text(year, style: const TextStyle(fontSize: 12, color: kGray500)),
      ]),
    ]),
  );
}
