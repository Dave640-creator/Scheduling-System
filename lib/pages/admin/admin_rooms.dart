import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/app_state.dart';
import '../../theme.dart';

class AdminRooms extends StatefulWidget {
  const AdminRooms({super.key});
  @override
  State<AdminRooms> createState() => _AdminRoomsState();
}

class _AdminRoomsState extends State<AdminRooms> {
  final _s = AppState();
  bool _showArchived = false;

  void _delete(int id) => showDialog(context: context, builder: (_) => AlertDialog(
    title: const Text('Delete Room'),
    content: const Text('Permanently remove this room?'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: kRed), onPressed: () { _s.rooms.removeWhere((r) => r.id == id); Navigator.pop(context); setState(() {}); }, child: const Text('Delete')),
    ],
  ));

  void _archive(int id) { final i = _s.rooms.indexWhere((r) => r.id == id); if (i != -1) { _s.rooms[i].isArchived = true; setState(() {}); } ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Room archived.'), backgroundColor: kGray700, duration: Duration(seconds: 2))); }
  void _unarchive(int id) { final i = _s.rooms.indexWhere((r) => r.id == id); if (i != -1) { _s.rooms[i].isArchived = false; setState(() {}); } }

  void _showModal({Room? editing}) {
    final nc = TextEditingController(text: editing?.name ?? '');
    final cc = TextEditingController(text: editing?.capacity.toString() ?? '');
    final isEdit = editing != null;
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(isEdit ? 'Edit Room' : 'Add Room', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nc, decoration: const InputDecoration(labelText: 'Room Name', hintText: 'e.g. Room 308')),
        const SizedBox(height: 12),
        TextField(controller: cc, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Capacity', hintText: 'e.g. 40')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          if (nc.text.isEmpty || cc.text.isEmpty) return;
          if (isEdit) { final i = _s.rooms.indexWhere((r) => r.id == editing.id); if (i != -1) { _s.rooms[i].name = nc.text; _s.rooms[i].capacity = int.tryParse(cc.text) ?? editing.capacity; } }
          else { _s.rooms.add(Room(id: _s.nextRoomId++, name: nc.text, capacity: int.tryParse(cc.text) ?? 0, status: 'Available')); }
          Navigator.pop(context); setState(() {});
        }, child: Text(isEdit ? 'Update' : 'Add Room')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final w        = MediaQuery.of(context).size.width;
    final isMobile = w < 640;
    final active   = _s.rooms.where((r) => !r.isArchived).toList();
    final archived = _s.rooms.where((r) => r.isArchived).toList();
    final display  = _showArchived ? archived : active;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, children: [
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Room Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: kGray900)),
            Text('Manage classroom and facility availability', style: TextStyle(fontSize: 13, color: kGray500)),
          ]),
          Row(mainAxisSize: MainAxisSize.min, children: [
            TextButton.icon(onPressed: () => setState(() => _showArchived = !_showArchived), icon: Icon(_showArchived ? Icons.visibility_off : Icons.archive_outlined, size: 16), label: Text(_showArchived ? 'Active' : 'Archived')),
            const SizedBox(width: 6),
            ElevatedButton.icon(onPressed: () => _showModal(), icon: const Icon(Icons.add, size: 16), label: const Text('Add Room')),
          ]),
        ]),
        const SizedBox(height: 16),

        // Stats
        GridView.count(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 2 : 4, mainAxisSpacing: 10, crossAxisSpacing: 10,
          childAspectRatio: isMobile ? 1.8 : 2.2,
          children: [
            _stat('Total', '${active.length}', kGray900),
            _stat('Available', '${active.where((r) => r.status == 'Available').length}', kGreen),
            _stat('Occupied', '${active.where((r) => r.status == 'Occupied').length}', kYellow),
            _stat('Archived', '${archived.length}', kGray500),
          ],
        ),
        const SizedBox(height: 16),

        if (_showArchived) _infoBanner('Showing archived rooms'),

        // Rooms — cards on mobile, table on desktop
        isMobile
          ? Column(children: display.map((r) => _mobileCard(r)).toList())
          : Container(
              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(kGray50),
                  columns: ['Room', 'Capacity', 'Status', 'Schedule', 'Actions']
                      .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
                  rows: display.map((r) => DataRow(cells: [
                    DataCell(Text(r.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900))),
                    DataCell(Text('${r.capacity}', style: const TextStyle(fontSize: 13, color: kGray500))),
                    DataCell(_statusBadge(r)),
                    DataCell(Text(r.assignedSchedule.isEmpty ? '—' : r.assignedSchedule, style: const TextStyle(fontSize: 12, color: kGray500))),
                    DataCell(Row(mainAxisSize: MainAxisSize.min, children: _showArchived
                      ? [Tooltip(message: 'Restore', child: IconButton(icon: const Icon(Icons.unarchive_outlined, size: 18, color: kGreen), onPressed: () => _unarchive(r.id))),
                         Tooltip(message: 'Delete',  child: IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: kRed), onPressed: () => _delete(r.id)))]
                      : [Tooltip(message: 'Edit',    child: IconButton(icon: const Icon(Icons.edit_outlined, size: 18, color: kBlue), onPressed: () => _showModal(editing: r))),
                         Tooltip(message: 'Archive', child: IconButton(icon: const Icon(Icons.archive_outlined, size: 18, color: kGray500), onPressed: () => _archive(r.id))),
                         Tooltip(message: 'Delete',  child: IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: kRed), onPressed: () => _delete(r.id)))])),
                  ])).toList(),
                ),
              ),
            ),
      ]),
    );
  }

  Widget _mobileCard(Room r) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(r.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kGray900))),
        _statusBadge(r),
      ]),
      const SizedBox(height: 4),
      Text('Capacity: ${r.capacity} students', style: const TextStyle(fontSize: 12, color: kGray500)),
      if (r.assignedSchedule.isNotEmpty) Text(r.assignedSchedule, style: const TextStyle(fontSize: 12, color: kGray400), overflow: TextOverflow.ellipsis),
      if (!r.isArchived) ...[
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () => _archive(r.id), icon: const Icon(Icons.archive_outlined, size: 14), label: const Text('Archive', style: TextStyle(fontSize: 12)), style: OutlinedButton.styleFrom(foregroundColor: kGray500))),
          const SizedBox(width: 8),
          Expanded(child: ElevatedButton.icon(onPressed: () => _showModal(editing: r), icon: const Icon(Icons.edit_outlined, size: 14), label: const Text('Edit', style: TextStyle(fontSize: 12)))),
        ]),
      ] else ...[
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: ElevatedButton.icon(onPressed: () => _unarchive(r.id), icon: const Icon(Icons.unarchive_outlined, size: 14), label: const Text('Restore', style: TextStyle(fontSize: 12)))),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton.icon(onPressed: () => _delete(r.id), icon: const Icon(Icons.delete_outline, size: 14), label: const Text('Delete', style: TextStyle(fontSize: 12)), style: OutlinedButton.styleFrom(foregroundColor: kRed, side: const BorderSide(color: kRed)))),
        ]),
      ],
    ]),
  );

  Widget _statusBadge(Room r) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: r.isArchived ? kGray100 : (r.status == 'Available' ? kGreenLight : kYellowLight),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(r.isArchived ? 'Archived' : r.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: r.isArchived ? kGray500 : (r.status == 'Available' ? kGreenDark : const Color(0xFF854D0E)))),
  );

  Widget _stat(String label, String value, Color color) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    padding: const EdgeInsets.all(12),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: color)),
      Text(label, style: const TextStyle(fontSize: 11, color: kGray500)),
    ]),
  );

  Widget _infoBanner(String msg) => Container(
    margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(color: kGray100, borderRadius: BorderRadius.circular(8)),
    child: Row(children: [const Icon(Icons.archive_outlined, size: 16, color: kGray500), const SizedBox(width: 8), Text(msg, style: const TextStyle(fontSize: 13, color: kGray500))]),
  );
}
