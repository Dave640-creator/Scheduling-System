// lib/pages/admin/admin_students.dart
import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../theme.dart';

class AdminStudents extends StatelessWidget {
  const AdminStudents({super.key});

  @override
  Widget build(BuildContext context) {
    final students = AppState.students;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Students',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
        const SizedBox(height: 4),
        const Text('Manage student enrollment and information',
            style: TextStyle(fontSize: 13, color: kGray500)),
        const SizedBox(height: 20),

        // Stats using Wrap (4 cards, responsive)
        Wrap(spacing: 12, runSpacing: 12, children: [
          _stat('Total Students', '${students.length}', kGray900),
          _stat('Active', '${students.where((s) => s.status == 'Active').length}', kGreen),
          _stat('CS Program',
              '${students.where((s) => s.program == 'BS Computer Science').length}', kBlue),
          _stat('IT Program',
              '${students.where((s) => s.program == 'BS Information Technology').length}',
              const Color(0xFF7C3AED)),
        ]),
        const SizedBox(height: 20),

        Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: kGray200),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(kGray50),
              columns: ['Student ID', 'Name', 'Email', 'Program', 'Year Level', 'Status']
                  .map((h) => DataColumn(
                        label: Text(h,
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)),
                      ))
                  .toList(),
              rows: students.map((s) => DataRow(cells: [
                DataCell(Text(s.studentId,
                    style: const TextStyle(fontSize: 13, color: kGray900))),
                DataCell(Text(s.name,
                    style: const TextStyle(fontSize: 13, color: kGray900))),
                DataCell(Text('📧 ${s.email}',
                    style: const TextStyle(fontSize: 12, color: kGray500))),
                DataCell(Text(s.program,
                    style: const TextStyle(fontSize: 13, color: kGray500))),
                DataCell(Text(s.yearLevel,
                    style: const TextStyle(fontSize: 13, color: kGray500))),
                DataCell(Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: s.status == 'Active' ? kGreenLight : kGray100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(s.status,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: s.status == 'Active' ? kGreenDark : kGray700)),
                )),
              ])).toList(),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _stat(String label, String value, Color color) => Container(
    width: 160,
    decoration: BoxDecoration(
      color: kWhite,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: kGray200),
    ),
    padding: const EdgeInsets.all(14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: kGray500)),
      const SizedBox(height: 6),
      Text(value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: color)),
    ]),
  );
}
