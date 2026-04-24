// lib/pages/admin/admin_instructors.dart
import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../theme.dart';

class AdminInstructors extends StatelessWidget {
  const AdminInstructors({super.key});
  @override
  Widget build(BuildContext context) {
    final instructors = AppState.instructors;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Instructors', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
        const SizedBox(height: 4),
        const Text('Manage instructor profiles and assignments', style: TextStyle(fontSize: 13, color: kGray500)),
        const SizedBox(height: 20),
        LayoutBuilder(builder: (ctx, c) => GridView.count(
          crossAxisCount: c.maxWidth > 500 ? 3 : 1, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 2.5,
          children: [
            _statCard('Total Instructors', '${instructors.length}', kGray900),
            _statCard('Active', '${instructors.where((i) => i.status == 'Active').length}', kGreen),
            _statCard('Total Subjects', '${instructors.fold(0, (s, i) => s + i.subjects)}', kBlue),
          ],
        )),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
          child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
            headingRowColor: WidgetStateProperty.all(kGray50),
            columns: ['Name', 'Contact', 'Department', 'Subjects', 'Status']
              .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
            rows: instructors.map((i) => DataRow(cells: [
              DataCell(Text(i.name, style: const TextStyle(fontSize: 13, color: kGray900))),
              DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('📧 ${i.email}', style: const TextStyle(fontSize: 12, color: kGray500)),
                Text('📞 ${i.phone}', style: const TextStyle(fontSize: 12, color: kGray500)),
              ])),
              DataCell(Text(i.department, style: const TextStyle(fontSize: 13, color: kGray500))),
              DataCell(Text('${i.subjects} subject(s)', style: const TextStyle(fontSize: 13, color: kGray900))),
              DataCell(Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: i.status == 'Active' ? kGreenLight : kGray100, borderRadius: BorderRadius.circular(20)),
                child: Text(i.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: i.status == 'Active' ? kGreenDark : kGray700)),
              )),
            ])).toList(),
          )),
        ),
      ]),
    );
  }

  Widget _statCard(String label, String value, Color color) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: kGray500)),
      const SizedBox(height: 8),
      Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: color)),
    ]),
  );
}
