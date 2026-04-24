// lib/pages/admin/admin_reports.dart
import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../theme.dart';

class AdminReports extends StatelessWidget {
  const AdminReports({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppState();
    final rooms = state.rooms;
    final schedules = state.schedules;
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final maxDay = days.map((d) => schedules.where((s) => s.day == d).length).reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Room Utilization Report', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
        const SizedBox(height: 4),
        const Text('Track and monitor classroom usage across all schedules', style: TextStyle(fontSize: 13, color: kGray500)),
        const SizedBox(height: 20),
        LayoutBuilder(builder: (ctx, c) => GridView.count(
          crossAxisCount: c.maxWidth > 500 ? 3 : 1, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 2.5,
          children: [
            _statCard('Total Rooms', '${rooms.length}', kGray900),
            _statCard('Utilization Rate', '${(rooms.where((r) => r.status == 'Occupied').length / rooms.length * 100).round()}%', kGreen),
            _statCard('Peak Day', 'Monday', kGray900),
          ],
        )),
        const SizedBox(height: 20),
        // Room usage table
        Container(
          decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
          child: Column(children: [
            const Padding(padding: EdgeInsets.all(16), child: Align(alignment: Alignment.centerLeft, child: Text('Room Usage Summary', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kGray900)))),
            const Divider(height: 1, color: kGray200),
            SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
              headingRowColor: WidgetStateProperty.all(kGray50),
              columns: ['Room', 'Capacity', 'Schedules Assigned', 'Days Used', 'Utilization', 'Status']
                .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
              rows: rooms.map((r) {
                final count = schedules.where((s) => s.room == r.name).length;
                final daysUsed = schedules.where((s) => s.room == r.name).map((s) => s.day).toSet().length;
                final util = (count / 5 * 100).clamp(0, 100).round();
                return DataRow(cells: [
                  DataCell(Text(r.name, style: const TextStyle(fontSize: 13, color: kGray900))),
                  DataCell(Text('${r.capacity}', style: const TextStyle(fontSize: 13, color: kGray500))),
                  DataCell(Text('$count', style: const TextStyle(fontSize: 13, color: kGray900))),
                  DataCell(Text('$daysUsed', style: const TextStyle(fontSize: 13, color: kGray900))),
                  DataCell(SizedBox(width: 120, child: Row(children: [
                    Expanded(child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: util / 100, minHeight: 8,
                        backgroundColor: kGray200,
                        valueColor: AlwaysStoppedAnimation(util > 60 ? kGreen : util > 30 ? kYellow : kGray300),
                      ),
                    )),
                    const SizedBox(width: 6),
                    Text('$util%', style: const TextStyle(fontSize: 12, color: kGray700)),
                  ]))),
                  DataCell(Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: r.status == 'Available' ? kGreenLight : kYellowLight, borderRadius: BorderRadius.circular(20)),
                    child: Text(r.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: r.status == 'Available' ? kGreenDark : const Color(0xFF854D0E))),
                  )),
                ]);
              }).toList(),
            )),
          ]),
        ),
        const SizedBox(height: 20),
        // Day chart
        Container(
          decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Schedule Count by Day', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kGray900)),
            const SizedBox(height: 16),
            ...days.map((day) {
              final count = schedules.where((s) => s.day == day).length;
              final pct = maxDay == 0 ? 0.0 : count / maxDay;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  SizedBox(width: 90, child: Text(day, style: const TextStyle(fontSize: 12, color: kGray500))),
                  Expanded(child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: pct.toDouble(), minHeight: 24, backgroundColor: kGray100, valueColor: const AlwaysStoppedAnimation(kGreen)),
                  )),
                  const SizedBox(width: 8),
                  SizedBox(width: 24, child: Text('$count', style: const TextStyle(fontSize: 12, color: kGray700))),
                ]),
              );
            }),
          ]),
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
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: color)),
    ]),
  );
}
