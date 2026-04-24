// lib/pages/admin/admin_dashboard.dart
import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState();
    final conflicts = state.schedules.where((s) => s.hasConflict).length;
    final pending = state.accounts.where((a) => a.status == 'Pending').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Dashboard', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: kGray900)),
        const SizedBox(height: 4),
        const Text('Welcome to the Academic Scheduling System', style: TextStyle(fontSize: 13, color: kGray500)),
        const SizedBox(height: 24),
        // Stats grid
        LayoutBuilder(builder: (ctx, constraints) {
          int cols = constraints.maxWidth > 600 ? 4 : 2;
          return GridView.count(
            crossAxisCount: cols, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.4,
            children: [
              _statCard('Total Schedules', '${state.schedules.length}', Icons.calendar_month_outlined, const Color(0xFF3B82F6)),
              _statCard('Pending Approvals', '${pending.length}', Icons.how_to_reg_outlined, kYellow),
              _statCard('Active Rooms', '12', Icons.meeting_room_outlined, kGreen),
              _statCard('Schedule Conflicts', '$conflicts', Icons.warning_amber_outlined, kRed),
            ],
          );
        }),
        const SizedBox(height: 20),
        // Two columns
        LayoutBuilder(builder: (ctx, constraints) {
          if (constraints.maxWidth > 700) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _conflictsCard(state)),
              const SizedBox(width: 20),
              Expanded(child: _pendingCard(pending)),
            ]);
          }
          return Column(children: [_conflictsCard(state), const SizedBox(height: 16), _pendingCard(pending)]);
        }),
      ]),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]),
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(width: 44, height: 44, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: kWhite, size: 22)),
      const SizedBox(height: 10),
      Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: kGray900)),
      Text(label, style: const TextStyle(fontSize: 12, color: kGray500)),
    ]),
  );

  Widget _conflictsCard(AppState state) {
    final conflicts = state.schedules.where((s) => s.hasConflict).toList();
    return Container(
      decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.all(16), child: Text('Conflict Alerts', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kGray900))),
        const Divider(height: 1, color: kGray200),
        Padding(
          padding: const EdgeInsets.all(16),
          child: conflicts.isEmpty
            ? const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text('No conflicts detected', style: TextStyle(color: kGray500, fontSize: 13))))
            : Column(children: conflicts.take(3).map((c) => _conflictItem(c.conflictType.isNotEmpty ? c.conflictType : 'Conflict', '${c.subject} - ${c.room} - ${c.day}')).toList()),
        ),
      ]),
    );
  }

  Widget _pendingCard(List pendingList) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.all(16), child: Text('Pending Account Approvals', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kGray900))),
      const Divider(height: 1, color: kGray200),
      Padding(
        padding: const EdgeInsets.all(16),
        child: pendingList.isEmpty
          ? const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text('No pending approvals', style: TextStyle(color: kGray500, fontSize: 13))))
          : Column(children: pendingList.take(3).map((a) => _pendingItem(a.name, a.email, a.role)).toList()),
      ),
    ]),
  );

  Widget _conflictItem(String type, String desc) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: kRedBg, border: Border.all(color: const Color(0xFFFECACA)), borderRadius: BorderRadius.circular(8)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.warning_amber_outlined, color: kRed, size: 18),
      const SizedBox(width: 8),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(type, style: const TextStyle(fontSize: 13, color: Color(0xFF991B1B), fontWeight: FontWeight.w600)),
        Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFFB91C1C))),
      ])),
    ]),
  );

  Widget _pendingItem(String name, String email, String role) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: kGray50, border: Border.all(color: kGray200), borderRadius: BorderRadius.circular(8)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900)),
      Text(email, style: const TextStyle(fontSize: 12, color: kGray500)),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: role == 'Instructor' ? kYellowLight : kBlueLight, borderRadius: BorderRadius.circular(20)),
        child: Text(role, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: role == 'Instructor' ? const Color(0xFF854D0E) : kBlue)),
      ),
    ]),
  );
}
