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
  final _s = AppState();
  bool _showArchived = false;
  final subjects     = ['Data Structures','Web Development','Database Systems','Mobile App Dev','System Analysis','Computer Networks','Software Engineering','Algorithms','OOP','Programming Lab','Discrete Mathematics','Operating Systems'];
  final instrList    = ['Dr. Santos','Prof. Cruz','Dr. Lopez','Prof. Garcia','Prof. Martinez','Dr. Reyes','Prof. Torres'];
  final roomList     = ['Room 301','Room 302','Room 303','Room 304','Room 305','Room 306','Room 307','Lab 201','Lab 202','Conference Hall'];
  final days         = ['Monday','Tuesday','Wednesday','Thursday','Friday'];
  final times        = ['7:00 AM - 9:00 AM','8:00 AM - 10:00 AM','9:00 AM - 11:00 AM','10:00 AM - 12:00 PM','1:00 PM - 3:00 PM','2:00 PM - 4:00 PM','3:00 PM - 5:00 PM'];

  void _refresh() => setState(() {});

  void _delete(int id) => showDialog(context: context, builder: (_) => AlertDialog(
    title: const Text('Delete Schedule'),
    content: const Text('Permanently delete this schedule? This cannot be undone.'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: kRed),
        onPressed: () { _s.schedules.removeWhere((s) => s.id == id); _s.detectConflicts(); Navigator.pop(context); _refresh(); },
        child: const Text('Delete')),
    ],
  ));

  void _archive(int id) {
    final idx = _s.schedules.indexWhere((s) => s.id == id);
    if (idx != -1) { _s.schedules[idx].isArchived = true; _s.detectConflicts(); _refresh(); }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Schedule archived.'), backgroundColor: kGray700, duration: Duration(seconds: 2)));
  }

  void _unarchive(int id) {
    final idx = _s.schedules.indexWhere((s) => s.id == id);
    if (idx != -1) { _s.schedules[idx].isArchived = false; _s.detectConflicts(); _refresh(); }
  }

  void _showModal({Schedule? editing}) {
    String subject    = editing?.subject    ?? subjects[0];
    String instructor = editing?.instructor ?? instrList[0];
    String room       = editing?.room       ?? roomList[0];
    String day        = editing?.day        ?? days[0];
    String time       = editing?.time       ?? times[0];
    final isEdit = editing != null;

    showDialog(context: context, builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => AlertDialog(
        title: Text(isEdit ? 'Edit Schedule' : 'Add New Schedule', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: SizedBox(width: double.maxFinite, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          _drop('Subject',    subject,    subjects,   (v) => setS(() => subject    = v!)),
          const SizedBox(height: 12),
          _drop('Instructor', instructor, instrList,  (v) => setS(() => instructor = v!)),
          const SizedBox(height: 12),
          _drop('Room',       room,       roomList,   (v) => setS(() => room       = v!)),
          const SizedBox(height: 12),
          _drop('Day',        day,        days,       (v) => setS(() => day        = v!)),
          const SizedBox(height: 12),
          _drop('Time Slot',  time,       times,      (v) => setS(() => time       = v!)),
        ]))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (isEdit) {
                final idx = _s.schedules.indexWhere((s) => s.id == editing.id);
                if (idx != -1) { _s.schedules[idx].subject = subject; _s.schedules[idx].instructor = instructor; _s.schedules[idx].room = room; _s.schedules[idx].day = day; _s.schedules[idx].time = time; }
              } else {
                _s.schedules.add(Schedule(id: _s.nextScheduleId++, subject: subject, instructor: instructor, room: room, day: day, time: time));
              }
              _s.detectConflicts(); Navigator.pop(ctx); _refresh();
            },
            child: Text(isEdit ? 'Update Schedule' : 'Save Schedule'),
          ),
        ],
      ),
    ));
  }

  void _autoGenerate() { _s.autoGenerateSchedules(); _refresh(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Schedules auto-generated!'), backgroundColor: kGreen, duration: Duration(seconds: 2))); }

  void _showReschedule(Schedule c) {
    final sug = <Map<String,String>>[];
    outer: for (final d in days) { for (final t in times) { for (final r in roomList) {
      if (d == c.day && t == c.time && r == c.room) continue;
      final rb = _s.schedules.any((s) => s.id != c.id && !s.isArchived && s.room == r && s.day == d && s.time == t);
      final ib = _s.schedules.any((s) => s.id != c.id && !s.isArchived && s.instructor == c.instructor && s.day == d && s.time == t);
      if (!rb && !ib) { sug.add({'day':d,'time':t,'room':r}); if (sug.length >= 5) break outer; }
    }}}
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: kGreenBg, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.swap_horiz, color: kGreen, size: 20)), const SizedBox(width: 10), const Text('Reschedule Suggestion', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))]),
      content: SizedBox(width: double.maxFinite, child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: kRedBg, border: Border.all(color: const Color(0xFFFECACA)), borderRadius: BorderRadius.circular(8)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [Icon(Icons.warning_amber_outlined, color: kRed, size: 15), SizedBox(width: 6), Text('Conflicted Schedule', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kRed))]),
            const SizedBox(height: 6),
            Text(c.subject, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900)),
            Text('${c.instructor}  •  ${c.room}  •  ${c.day} ${c.time}', style: const TextStyle(fontSize: 12, color: kGray700)),
            Text(c.conflictType, style: const TextStyle(fontSize: 11, color: kRed)),
          ])),
        const SizedBox(height: 14),
        const Text('Available Slots:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        if (sug.isEmpty) const Text('No available slots found.', style: TextStyle(fontSize: 13, color: kGray500))
        else ...sug.asMap().entries.map((e) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(color: kGreenBg, border: Border.all(color: const Color(0xFFBBF7D0)), borderRadius: BorderRadius.circular(8)),
          child: ListTile(dense: true,
            leading: Container(width: 28, height: 28, decoration: const BoxDecoration(color: kGreen, shape: BoxShape.circle), child: Center(child: Text('${e.key+1}', style: const TextStyle(color: kWhite, fontSize: 12, fontWeight: FontWeight.w700)))),
            title: Text('${e.value['day']}  •  ${e.value['time']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            subtitle: Text('Room: ${e.value['room']}', style: const TextStyle(fontSize: 12, color: kGray700)),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), textStyle: const TextStyle(fontSize: 12)),
              onPressed: () {
                final idx = _s.schedules.indexWhere((s) => s.id == c.id);
                if (idx != -1) { _s.schedules[idx].day = e.value['day']!; _s.schedules[idx].time = e.value['time']!; _s.schedules[idx].room = e.value['room']!; _s.detectConflicts(); }
                Navigator.pop(context); _refresh();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${c.subject} rescheduled to ${e.value['day']} ${e.value['time']}'), backgroundColor: kGreen, duration: const Duration(seconds: 3)));
              },
              child: const Text('Apply'),
            ),
          ),
        )),
      ]))),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
    ));
  }

  Widget _drop(String label, String value, List<String> items, ValueChanged<String?> cb) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)), const SizedBox(height: 4),
      Container(decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButton<String>(value: value, isExpanded: true, underline: const SizedBox(), items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(), onChanged: cb)),
    ]);

  Widget _mobileCard(Schedule s) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: s.hasConflict ? kRedBg : kWhite,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: s.hasConflict ? const Color(0xFFFECACA) : kGray200),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(s.subject, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kGray900))),
        s.hasConflict
          ? Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: kRedLight, borderRadius: BorderRadius.circular(20)), child: const Text('Conflict', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kRed)))
          : Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(20)), child: const Text('OK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGreenDark))),
      ]),
      const SizedBox(height: 6),
      _detailRow(Icons.person_outline,        s.instructor),
      const SizedBox(height: 2),
      _detailRow(Icons.meeting_room_outlined,  s.room),
      const SizedBox(height: 2),
      _detailRow(Icons.today_outlined,         '${s.day}  •  ${s.time}'),
      if (s.hasConflict) Padding(padding: const EdgeInsets.only(top: 4), child: Text(s.conflictType, style: const TextStyle(fontSize: 11, color: kRed))),
      const SizedBox(height: 10),
      Row(children: [
        if (s.hasConflict) Expanded(child: ElevatedButton.icon(onPressed: () => _showReschedule(s), icon: const Icon(Icons.swap_horiz, size: 14), label: const Text('Reschedule', style: TextStyle(fontSize: 12)), style: ElevatedButton.styleFrom(backgroundColor: kGreen))),
        if (s.hasConflict) const SizedBox(width: 6),
        Expanded(child: OutlinedButton.icon(onPressed: () => _archive(s.id), icon: const Icon(Icons.archive_outlined, size: 14), label: const Text('Archive', style: TextStyle(fontSize: 12)), style: OutlinedButton.styleFrom(foregroundColor: kGray500))),
        const SizedBox(width: 6),
        Expanded(child: ElevatedButton.icon(onPressed: () => _showModal(editing: s), icon: const Icon(Icons.edit_outlined, size: 14), label: const Text('Edit', style: TextStyle(fontSize: 12)))),
      ]),
    ]),
  );

  Widget _detailRow(IconData icon, String text) => Row(children: [
    Icon(icon, size: 13, color: kGray400), const SizedBox(width: 6),
    Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: kGray600), overflow: TextOverflow.ellipsis)),
  ]);

  @override
  Widget build(BuildContext context) {
    final w        = MediaQuery.of(context).size.width;
    final isMobile = w < 640;
    final active   = _s.schedules.where((s) => !s.isArchived).toList();
    final archived = _s.schedules.where((s) => s.isArchived).toList();
    final display  = _showArchived ? archived : active;
    final conflicts = active.where((s) => s.hasConflict).toList();

    return SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, children: [
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Manage Schedules', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
          Text('Add, edit, archive schedules and detect conflicts', style: TextStyle(fontSize: 13, color: kGray500)),
        ]),
        Row(mainAxisSize: MainAxisSize.min, children: [
          TextButton.icon(onPressed: () => setState(() => _showArchived = !_showArchived), icon: Icon(_showArchived ? Icons.visibility_off : Icons.archive_outlined, size: 16), label: Text(_showArchived ? 'Hide Archived' : 'View Archived')),
          const SizedBox(width: 8),
          ElevatedButton.icon(onPressed: _autoGenerate, icon: const Icon(Icons.auto_fix_high, size: 16), label: const Text('Auto-Generate'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB))),
          const SizedBox(width: 8),
          ElevatedButton.icon(onPressed: () => _showModal(), icon: const Icon(Icons.add, size: 16), label: const Text('Add Schedule')),
        ]),
      ]),
      const SizedBox(height: 16),

      // Stats row
      Row(children: [
        _chip('Total', '${active.length}', kGray900), const SizedBox(width: 10),
        _chip('Conflicts', '${conflicts.length}', kRed), const SizedBox(width: 10),
        _chip('Archived', '${archived.length}', kGray500),
      ]),
      const SizedBox(height: 16),

      if (!_showArchived && conflicts.isNotEmpty)
        Container(margin: const EdgeInsets.only(bottom: 12), width: double.infinity, padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: kRedBg, border: Border.all(color: const Color(0xFFFECACA)), borderRadius: BorderRadius.circular(8)),
          child: Row(children: [const Icon(Icons.warning_amber_outlined, color: kRed, size: 18), const SizedBox(width: 8), Expanded(child: Text('${conflicts.length} conflict(s) detected. Tap the swap icon to resolve.', style: const TextStyle(fontSize: 13, color: Color(0xFF991B1B))))])),

      if (_showArchived)
        Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: kGray100, borderRadius: BorderRadius.circular(8)),
          child: const Row(children: [Icon(Icons.archive_outlined, size: 16, color: kGray500), SizedBox(width: 8), Text('Showing archived schedules', style: TextStyle(fontSize: 13, color: kGray500))])),

      isMobile
        ? Column(children: display.map((s) => _mobileCard(s)).toList())
        : Container(
        decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
          headingRowColor: WidgetStateProperty.all(kGray50),
          columns: ['Subject','Instructor','Room','Day','Time','Status','Actions']
              .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
          rows: display.map((s) => DataRow(
            color: WidgetStateProperty.all(s.hasConflict ? kRedBg : kWhite),
            cells: [
              DataCell(Text(s.subject,    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900))),
              DataCell(Text(s.instructor, style: const TextStyle(fontSize: 13, color: kGray700))),
              DataCell(Text(s.room,       style: const TextStyle(fontSize: 13, color: kGray700))),
              DataCell(Text(s.day,        style: const TextStyle(fontSize: 13, color: kGray700))),
              DataCell(Text(s.time,       style: const TextStyle(fontSize: 13, color: kGray700))),
              DataCell(s.isArchived
                ? Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: kGray100, borderRadius: BorderRadius.circular(20)), child: const Text('Archived', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))
                : s.hasConflict
                  ? Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: kRedLight, borderRadius: BorderRadius.circular(20)), child: const Text('Conflict', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kRed)))
                  : Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(20)), child: const Text('OK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGreenDark)))),
              DataCell(Row(mainAxisSize: MainAxisSize.min, children: _showArchived ? [
                Tooltip(message: 'Restore',child: IconButton(icon: const Icon(Icons.unarchive_outlined, size: 18, color: kGreen), onPressed: () => _unarchive(s.id))),
                Tooltip(message: 'Delete', child: IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: kRed), onPressed: () => _delete(s.id))),
              ] : [
                if (s.hasConflict) Tooltip(message: 'Suggest Reschedule', child: IconButton(icon: const Icon(Icons.swap_horiz, size: 18, color: kGreen), onPressed: () => _showReschedule(s))),
                Tooltip(message: 'Edit',    child: IconButton(icon: const Icon(Icons.edit_outlined,    size: 18, color: kBlue),    onPressed: () => _showModal(editing: s))),
                Tooltip(message: 'Archive', child: IconButton(icon: const Icon(Icons.archive_outlined, size: 18, color: kGray500), onPressed: () => _archive(s.id))),
                Tooltip(message: 'Delete',  child: IconButton(icon: const Icon(Icons.delete_outline,   size: 18, color: kRed),     onPressed: () => _delete(s.id))),
              ])),
            ],
          )).toList(),
        )),
      ),
    ]));
  }

  Widget _chip(String label, String value, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(color: kWhite, border: Border.all(color: kGray200), borderRadius: BorderRadius.circular(8)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 12, color: kGray500)),
    ]),
  );
}
