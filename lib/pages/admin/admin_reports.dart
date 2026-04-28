// lib/pages/admin/admin_reports.dart
import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/app_state.dart';
import '../../theme.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({super.key});
  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  final state = AppState();

  final reportTypes = ['Room Utilization Report', 'Instructor Workload Report', 'Conflict Summary Report', 'Schedule Coverage Report', 'Student Enrollment Report'];
  final terms = ['1st Semester 2025-2026', '2nd Semester 2025-2026', '1st Semester 2024-2025', '2nd Semester 2024-2025'];

  void _showCreateModal() {
    String selectedType = reportTypes[0];
    String selectedTerm = terms[0];

    showDialog(context: context, builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => AlertDialog(
        title: const Text('Create Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: SizedBox(width: double.maxFinite, child: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Report Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)),
            const SizedBox(height: 4),
            Container(decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(value: selectedType, isExpanded: true, underline: const SizedBox(), items: reportTypes.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13)))).toList(), onChanged: (v) => setS(() => selectedType = v!))),
          ]),
          const SizedBox(height: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Academic Term', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)),
            const SizedBox(height: 4),
            Container(decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(value: selectedTerm, isExpanded: true, underline: const SizedBox(), items: terms.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13)))).toList(), onChanged: (v) => setS(() => selectedTerm = v!))),
          ]),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton.icon(
            icon: const Icon(Icons.bar_chart, size: 16),
            onPressed: () {
              final now = DateTime.now();
              state.reports.insert(0, Report(id: state.nextReportId++, type: selectedType, term: selectedTerm, dateGenerated: '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}', generatedBy: 'Administrator'));
              Navigator.pop(ctx); setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report generated successfully!'), backgroundColor: kGreen, duration: Duration(seconds: 2)));
            },
            label: const Text('Generate Report'),
          ),
        ],
      ),
    ));
  }

  void _deleteReport(int id) {
    state.reports.removeWhere((r) => r.id == id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final schedules = state.schedules;
    final rooms = state.rooms.where((r) => !r.isArchived).toList();
    final utilRate = rooms.isEmpty ? 0 : ((rooms.where((r) => r.status == 'Occupied').length / rooms.length) * 100).round();

    return SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      // Header
      Row(children: [
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Reports', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
          Text('View system-generated reports and analytics', style: TextStyle(fontSize: 13, color: kGray500)),
        ])),
        ElevatedButton.icon(onPressed: _showCreateModal, icon: const Icon(Icons.add, size: 16), label: const Text('Create Report')),
      ]),
      const SizedBox(height: 20),

      // Summary stats
      Row(children: [
        Expanded(child: _stat('Total Schedules', '${schedules.length}', kGray900, Icons.calendar_month_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _stat('Conflicts', '${schedules.where((s) => s.hasConflict).length}', kRed, Icons.warning_amber_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _stat('Room Utilization', '$utilRate%', kGreen, Icons.meeting_room_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _stat('Active Instructors', '${state.instructors.where((i) => i.status == 'Active').length}', kBlue, Icons.people_outline)),
      ]),
      const SizedBox(height: 24),

      // Room Utilization table
      _sectionCard('Room Utilization Report', Icons.meeting_room_outlined, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
        headingRowColor: WidgetStateProperty.all(kGray50),
        columns: ['Room', 'Capacity', 'Schedules', 'Days Used', 'Utilization', 'Status']
            .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
        rows: rooms.map((r) {
          final sched = schedules.where((s) => s.room == r.name).toList();
          final daysUsed = sched.map((s) => s.day).toSet().length;
          final util = ((daysUsed / 5) * 100).round();
          return DataRow(cells: [
            DataCell(Text(r.name, style: const TextStyle(fontSize: 13, color: kGray900))),
            DataCell(Text('${r.capacity}', style: const TextStyle(fontSize: 13, color: kGray500))),
            DataCell(Text('${sched.length}', style: const TextStyle(fontSize: 13, color: kGray900))),
            DataCell(Text('$daysUsed', style: const TextStyle(fontSize: 13, color: kGray500))),
            DataCell(Row(children: [
              Container(width: 60, height: 6, decoration: BoxDecoration(color: kGray200, borderRadius: BorderRadius.circular(3)),
                child: FractionallySizedBox(widthFactor: util / 100, alignment: Alignment.centerLeft, child: Container(decoration: BoxDecoration(color: util > 60 ? kGreen : kYellow, borderRadius: BorderRadius.circular(3))))),
              const SizedBox(width: 8),
              Text('$util%', style: const TextStyle(fontSize: 12, color: kGray700)),
            ])),
            DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: r.status == 'Available' ? kGreenLight : kYellowLight, borderRadius: BorderRadius.circular(20)), child: Text(r.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: r.status == 'Available' ? kGreenDark : const Color(0xFF854D0E))))),
          ]);
        }).toList(),
      ))),
      const SizedBox(height: 16),

      // Schedule per day breakdown
      _sectionCard('Schedule Coverage by Day', Icons.bar_chart_outlined, child: Column(children: days.map((day) {
        final count = schedules.where((s) => s.day == day).length;
        final max = 10;
        return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
          SizedBox(width: 90, child: Text(day, style: const TextStyle(fontSize: 13, color: kGray700))),
          Expanded(child: Container(height: 20, decoration: BoxDecoration(color: kGray100, borderRadius: BorderRadius.circular(4)),
            child: FractionallySizedBox(widthFactor: (count / max).clamp(0.0, 1.0), alignment: Alignment.centerLeft,
              child: Container(decoration: BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(4)))))),
          const SizedBox(width: 10),
          Text('$count', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900)),
        ]));
      }).toList())),
      const SizedBox(height: 16),

      // Generated reports history
      _sectionCard('Generated Reports', Icons.description_outlined, child: state.reports.isEmpty
        ? const Padding(padding: EdgeInsets.all(16), child: Text('No reports generated yet.', style: TextStyle(fontSize: 13, color: kGray500)))
        : Column(children: state.reports.map((r) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kGray200, width: 0.5))),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: kBlueLight, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.description_outlined, size: 18, color: kBlue)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.type, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900)),
              Text('${r.term}  •  Generated ${r.dateGenerated}  •  By ${r.generatedBy}', style: const TextStyle(fontSize: 12, color: kGray500)),
            ])),
            Tooltip(message: 'Download (demo)', child: IconButton(icon: const Icon(Icons.download_outlined, size: 18, color: kBlue), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download feature — connect to backend to export PDF/CSV.'), duration: Duration(seconds: 2))))),
            Tooltip(message: 'Delete', child: IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: kRed), onPressed: () => _deleteReport(r.id))),
          ]),
        )).toList()),
      ),
    ]));
  }

  Widget _stat(String label, String value, Color color, IconData icon) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    padding: const EdgeInsets.all(16),
    child: Row(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 22)),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: kGray500)),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
      ]),
    ]),
  );

  Widget _sectionCard(String title, IconData icon, {required Widget child}) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.all(16), child: Row(children: [Icon(icon, size: 18, color: kGray700), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kGray900))])),
      const Divider(height: 1, color: kGray200),
      Padding(padding: const EdgeInsets.all(16), child: child),
    ]),
  );
}
