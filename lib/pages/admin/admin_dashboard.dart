import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final state     = AppState();
    final conflicts = state.schedules.where((s) => s.hasConflict && !s.isArchived).toList();
    final pending   = state.accounts.where((a) => a.status == 'Pending').toList();
    final w         = MediaQuery.of(context).size.width;
    final isWide    = w > 700;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: kGray900)),
        const SizedBox(height: 2),
        const Text('Welcome to the Academic Scheduling System', style: TextStyle(fontSize: 13, color: kGray500)),
        const SizedBox(height: 20),

        // Stat cards — always 2 cols on mobile, 4 on wide
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWide ? 4 : 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: isWide ? 1.5 : 1.4,
          children: [
            _statCard('Total Schedules',   '${state.schedules.where((s) => !s.isArchived).length}', Icons.calendar_month_outlined, const Color(0xFF3B82F6)),
            _statCard('Pending Approvals', '${pending.length}',     Icons.how_to_reg_outlined,      kYellow),
            _statCard('Active Rooms',      '${state.rooms.where((r) => !r.isArchived).length}', Icons.meeting_room_outlined, kGreen),
            _statCard('Conflicts',         '${conflicts.length}',   Icons.warning_amber_outlined,   kRed),
          ],
        ),
        const SizedBox(height: 20),

        isWide
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _conflictsCard(conflicts)),
              const SizedBox(width: 16),
              Expanded(child: _pendingCard(pending)),
            ])
          : Column(children: [
              _conflictsCard(conflicts),
              const SizedBox(height: 16),
              _pendingCard(pending),
            ]),
      ]),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) =>
    Container(
      decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]),
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: kWhite, size: 20)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: kGray900)),
        Text(label, style: const TextStyle(fontSize: 11, color: kGray500)),
      ]),
    );

  Widget _conflictsCard(List conflicts) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.all(16), child: Text('Conflict Alerts', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kGray900))),
      const Divider(height: 1, color: kGray200),
      Padding(
        padding: const EdgeInsets.all(14),
        child: conflicts.isEmpty
          ? const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Center(child: Text('No conflicts detected ✓', style: TextStyle(color: kGray500, fontSize: 13))))
          : Column(children: conflicts.take(4).map((c) => Container(
              margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: kRedBg, border: Border.all(color: const Color(0xFFFECACA)), borderRadius: BorderRadius.circular(8)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.warning_amber_outlined, color: kRed, size: 16), const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c.conflictType, style: const TextStyle(fontSize: 12, color: Color(0xFF991B1B), fontWeight: FontWeight.w600)),
                  Text('${c.subject}  •  ${c.room}  •  ${c.day}', style: const TextStyle(fontSize: 11, color: Color(0xFFB91C1C)), overflow: TextOverflow.ellipsis),
                ])),
              ]),
            )).toList()),
      ),
    ]),
  );

  Widget _pendingCard(List pending) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.all(16), child: Text('Pending Approvals', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kGray900))),
      const Divider(height: 1, color: kGray200),
      Padding(
        padding: const EdgeInsets.all(14),
        child: pending.isEmpty
          ? const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Center(child: Text('No pending approvals', style: TextStyle(color: kGray500, fontSize: 13))))
          : Column(children: pending.take(4).map((a) => Container(
              margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: kGray50, border: Border.all(color: kGray200), borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900), overflow: TextOverflow.ellipsis),
                  Text(a.email, style: const TextStyle(fontSize: 11, color: kGray500), overflow: TextOverflow.ellipsis),
                ])),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: a.role == 'Instructor' ? kYellowLight : kBlueLight, borderRadius: BorderRadius.circular(20)),
                  child: Text(a.role, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: a.role == 'Instructor' ? const Color(0xFF854D0E) : kBlue)),
                ),
              ]),
            )).toList()),
      ),
    ]),
  );
}
