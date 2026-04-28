import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../theme.dart';

class AdminStudents extends StatelessWidget {
  const AdminStudents({super.key});

  @override
  Widget build(BuildContext context) {
    final students = AppState.students;
    final w        = MediaQuery.of(context).size.width;
    final isMobile = w < 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Students', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: kGray900)),
        const SizedBox(height: 2),
        const Text('Manage student enrollment and information', style: TextStyle(fontSize: 13, color: kGray500)),
        const SizedBox(height: 16),

        // Stat cards — 2 cols always
        GridView.count(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 2 : 4,
          mainAxisSpacing: 10, crossAxisSpacing: 10,
          childAspectRatio: isMobile ? 1.6 : 2.0,
          children: [
            _stat('Total', '${students.length}', kGray900),
            _stat('Active', '${students.where((s) => s.status == 'Active').length}', kGreen),
            _stat('BSCS', '${students.where((s) => s.program == 'BS Computer Science').length}', kBlue),
            _stat('BSIT', '${students.where((s) => s.program == 'BS Information Technology').length}', const Color(0xFF7C3AED)),
          ],
        ),
        const SizedBox(height: 16),

        isMobile
          ? Column(children: students.map((s) => _mobileCard(s)).toList())
          : Container(
              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(kGray50),
                  columns: ['ID', 'Name', 'Email', 'Program', 'Year', 'Status']
                      .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
                  rows: students.map((s) => DataRow(cells: [
                    DataCell(Text(s.studentId, style: const TextStyle(fontSize: 12, color: kGray900, fontFamily: 'monospace'))),
                    DataCell(Text(s.name,       style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray900))),
                    DataCell(Text(s.email,      style: const TextStyle(fontSize: 12, color: kGray500))),
                    DataCell(Text(s.program,    style: const TextStyle(fontSize: 12, color: kGray700))),
                    DataCell(Text(s.yearLevel,  style: const TextStyle(fontSize: 12, color: kGray500))),
                    DataCell(_badge(s.status)),
                  ])).toList(),
                ),
              ),
            ),
      ]),
    );
  }

  Widget _mobileCard(s) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    child: Row(children: [
      CircleAvatar(backgroundColor: kGreenBg, child: Text(s.name[0], style: const TextStyle(color: kGreen, fontWeight: FontWeight.w700))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kGray900)),
        Text(s.studentId, style: const TextStyle(fontSize: 11, color: kGray500, fontFamily: 'monospace')),
        Text('${s.program}  •  ${s.yearLevel}', style: const TextStyle(fontSize: 11, color: kGray500), overflow: TextOverflow.ellipsis),
      ])),
      _badge(s.status),
    ]),
  );

  Widget _badge(String status) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: status == 'Active' ? kGreenLight : kGray100, borderRadius: BorderRadius.circular(20)),
    child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: status == 'Active' ? kGreenDark : kGray700)),
  );

  Widget _stat(String label, String value, Color color) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    padding: const EdgeInsets.all(12),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: color)),
      Text(label, style: const TextStyle(fontSize: 11, color: kGray500)),
    ]),
  );
}
