// lib/pages/admin/admin_schedules.dart
import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/app_state.dart';
import '../../theme.dart';

class AdminSchedules extends StatefulWidget {
  const AdminSchedules({super.key});
  @override
  State<AdminSchedules> createState() => _AdminSchedulesState();
}

class _AdminSchedulesState extends State<AdminSchedules> {
  final state = AppState();

  final subjects = ['Data Structures', 'Web Development', 'Database Systems', 'Mobile App Dev', 'System Analysis', 'Computer Networks', 'Software Engineering', 'Algorithms', 'Object Oriented Programming', 'Programming Lab'];
  final instructorList = ['Dr. Santos', 'Prof. Cruz', 'Dr. Lopez', 'Prof. Garcia', 'Prof. Martinez', 'Dr. Reyes', 'Prof. Torres'];
  final roomList = ['Room 301', 'Room 302', 'Room 303', 'Room 304', 'Room 305', 'Room 306', 'Room 307', 'Lab 201', 'Lab 202'];
  final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  final times = ['7:00 AM - 9:00 AM', '8:00 AM - 10:00 AM', '9:00 AM - 11:00 AM', '10:00 AM - 12:00 PM', '1:00 PM - 3:00 PM', '2:00 PM - 4:00 PM', '3:00 PM - 5:00 PM'];

  void _refresh() => setState(() {});

  void _delete(int id) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Delete Schedule'),
      content: const Text('Are you sure you want to delete this schedule?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kRed),
          onPressed: () { state.schedules.removeWhere((s) => s.id == id); state.detectConflicts(); Navigator.pop(context); _refresh(); },
          child: const Text('Delete'),
        ),
      ],
    ));
  }

  void _showAddModal() {
    String subject = subjects[0], instructor = instructorList[0], room = roomList[0], day = days[0], time = times[0];
    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => AlertDialog(
      title: const Text('Add New Schedule'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        _modalDropdown('Subject', subject, subjects, (v) => setS(() => subject = v!)),
        const SizedBox(height: 12),
        _modalDropdown('Instructor', instructor, instructorList, (v) => setS(() => instructor = v!)),
        const SizedBox(height: 12),
        _modalDropdown('Room', room, roomList, (v) => setS(() => room = v!)),
        const SizedBox(height: 12),
        _modalDropdown('Day', day, days, (v) => setS(() => day = v!)),
        const SizedBox(height: 12),
        _modalDropdown('Time', time, times, (v) => setS(() => time = v!)),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            state.schedules.add(Schedule(id: state.nextScheduleId++, subject: subject, instructor: instructor, room: room, day: day, time: time));
            state.detectConflicts();
            Navigator.pop(ctx);
            _refresh();
          },
          child: const Text('Save Schedule'),
        ),
      ],
    )));
  }

  void _autoGenerate() {
    state.autoGenerateSchedules();
    _refresh();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('✅ Schedules auto-generated successfully!'),
      backgroundColor: kGreen,
    ));
  }

  Widget _modalDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) => Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)),
      const SizedBox(height: 4),
      Container(
        decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButton<String>(value: value, isExpanded: true, underline: const SizedBox(), items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(), onChanged: onChanged),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final schedules = state.schedules;
    final conflicts = schedules.where((s) => s.hasConflict).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Manage Schedules', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
            Text('Create and manage class schedules with conflict detection', style: TextStyle(fontSize: 13, color: kGray500)),
          ])),
          ElevatedButton.icon(
            onPressed: _autoGenerate,
            icon: const Icon(Icons.auto_fix_high, size: 16),
            label: const Text('Auto-Generate'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _showAddModal,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add Schedule'),
          ),
        ]),
        const SizedBox(height: 16),
        if (conflicts.isNotEmpty)
          Container(
            width: double.infinity, padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: kRedBg, border: Border.all(color: const Color(0xFFFECACA)), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.warning_amber_outlined, color: kRed, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('${conflicts.length} schedule conflict(s) detected — please review and resolve conflicts highlighted in red below.', style: const TextStyle(fontSize: 13, color: Color(0xFF991B1B)))),
            ]),
          ),
        Container(
          decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]),
          child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
            headingRowColor: WidgetStateProperty.all(kGray50),
            columns: const [
              DataColumn(label: Text('Subject', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500))),
              DataColumn(label: Text('Instructor', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500))),
              DataColumn(label: Text('Room', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500))),
              DataColumn(label: Text('Day', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500))),
              DataColumn(label: Text('Time', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500))),
              DataColumn(label: Text('Status', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500))),
              DataColumn(label: Text('Actions', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500))),
            ],
            rows: schedules.map((s) => DataRow(
              color: WidgetStateProperty.all(s.hasConflict ? kRedBg : kWhite),
              cells: [
                DataCell(Text(s.subject, style: const TextStyle(fontSize: 13, color: kGray900))),
                DataCell(Text(s.instructor, style: const TextStyle(fontSize: 13, color: kGray900))),
                DataCell(Text(s.room, style: const TextStyle(fontSize: 13, color: kGray900))),
                DataCell(Text(s.day, style: const TextStyle(fontSize: 13, color: kGray700))),
                DataCell(Text(s.time, style: const TextStyle(fontSize: 13, color: kGray700))),
                DataCell(s.hasConflict
                  ? Row(children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: kRedLight, borderRadius: BorderRadius.circular(20)), child: const Text('Conflict', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kRed))),
                      const SizedBox(width: 4),
                      const Icon(Icons.warning_amber_outlined, color: kRed, size: 16),
                    ])
                  : Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(20)), child: const Text('Available', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGreenDark))),
                ),
                DataCell(Row(children: [
                  IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: kRed), onPressed: () => _delete(s.id), tooltip: 'Delete'),
                ])),
              ],
            )).toList(),
          )),
        ),
        if (conflicts.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(padding: EdgeInsets.all(16), child: Text('Conflict Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kGray900))),
              const Divider(height: 1, color: kGray200),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: conflicts.map((c) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: kRedBg, border: Border.all(color: const Color(0xFFFECACA)), borderRadius: BorderRadius.circular(8)),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.warning_amber_outlined, color: kRed, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(c.conflictType, style: const TextStyle(fontSize: 13, color: Color(0xFF991B1B), fontWeight: FontWeight.w600)),
                      Text('${c.subject} — ${c.instructor} — ${c.room} — ${c.day} ${c.time}', style: const TextStyle(fontSize: 12, color: Color(0xFFB91C1C))),
                    ])),
                  ]),
                )).toList()),
              ),
            ]),
          ),
        ],
      ]),
    );
  }
}
