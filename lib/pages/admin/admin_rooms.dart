// lib/pages/admin/admin_rooms.dart
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
  final state = AppState();
  bool _showArchived = false;

  void _delete(int id) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Delete Room'),
      content: const Text('Are you sure? This will permanently remove the room.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: kRed), onPressed: () { state.rooms.removeWhere((r) => r.id == id); Navigator.pop(context); setState(() {}); }, child: const Text('Delete')),
      ],
    ));
  }

  void _archive(int id) {
    final idx = state.rooms.indexWhere((r) => r.id == id);
    if (idx != -1) { state.rooms[idx].isArchived = true; setState(() {}); }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Room archived.'), backgroundColor: kGray700, duration: Duration(seconds: 2)));
  }

  void _unarchive(int id) {
    final idx = state.rooms.indexWhere((r) => r.id == id);
    if (idx != -1) { state.rooms[idx].isArchived = false; setState(() {}); }
  }

  void _showModal({Room? editing}) {
    final nameCtrl = TextEditingController(text: editing?.name ?? '');
    final capCtrl  = TextEditingController(text: editing?.capacity.toString() ?? '');
    final isEdit = editing != null;

    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(isEdit ? 'Edit Room' : 'Add New Room', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Room Name', hintText: 'e.g. Room 308')),
        const SizedBox(height: 12),
        TextField(controller: capCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Capacity', hintText: 'e.g. 40')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (nameCtrl.text.isEmpty || capCtrl.text.isEmpty) return;
            if (isEdit) {
              final idx = state.rooms.indexWhere((r) => r.id == editing.id);
              if (idx != -1) { state.rooms[idx].name = nameCtrl.text; state.rooms[idx].capacity = int.tryParse(capCtrl.text) ?? editing.capacity; }
            } else {
              state.rooms.add(Room(id: state.nextRoomId++, name: nameCtrl.text, capacity: int.tryParse(capCtrl.text) ?? 0, status: 'Available'));
            }
            Navigator.pop(context); setState(() {});
          },
          child: Text(isEdit ? 'Update Room' : 'Add Room'),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final activeRooms   = state.rooms.where((r) => !r.isArchived).toList();
    final archivedRooms = state.rooms.where((r) => r.isArchived).toList();
    final displayRooms  = _showArchived ? archivedRooms : activeRooms;
    final avail = activeRooms.where((r) => r.status == 'Available').length;
    final occ   = activeRooms.where((r) => r.status == 'Occupied').length;

    return SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Room Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
          const Text('Manage classroom and facility availability', style: TextStyle(fontSize: 13, color: kGray500)),
        ])),
        TextButton.icon(onPressed: () => setState(() => _showArchived = !_showArchived), icon: Icon(_showArchived ? Icons.visibility_off : Icons.archive_outlined, size: 16), label: Text(_showArchived ? 'Hide Archived' : 'View Archived')),
        const SizedBox(width: 8),
        ElevatedButton.icon(onPressed: () => _showModal(), icon: const Icon(Icons.add, size: 16), label: const Text('Add Room')),
      ]),
      const SizedBox(height: 20),

      Row(children: [
        Expanded(child: _statCard('Total Rooms', '${activeRooms.length}', kGray900)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Available', '$avail', kGreen)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Occupied', '$occ', kYellow)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Archived', '${archivedRooms.length}', kGray500)),
      ]),
      const SizedBox(height: 20),

      if (_showArchived)
        Padding(padding: const EdgeInsets.only(bottom: 12), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: kGray100, borderRadius: BorderRadius.circular(8)), child: const Row(children: [Icon(Icons.archive_outlined, size: 16, color: kGray500), SizedBox(width: 8), Text('Showing archived rooms', style: TextStyle(fontSize: 13, color: kGray500))]))),

      Container(
        decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
          headingRowColor: WidgetStateProperty.all(kGray50),
          columns: ['Room Name', 'Capacity', 'Status', 'Assigned Schedule', 'Actions']
              .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
          rows: displayRooms.map((r) => DataRow(cells: [
            DataCell(Text(r.name, style: const TextStyle(fontSize: 13, color: kGray900))),
            DataCell(Text('${r.capacity} students', style: const TextStyle(fontSize: 13, color: kGray500))),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: r.isArchived ? kGray100 : (r.status == 'Available' ? kGreenLight : kYellowLight), borderRadius: BorderRadius.circular(20)),
              child: Text(r.isArchived ? 'Archived' : r.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: r.isArchived ? kGray500 : (r.status == 'Available' ? kGreenDark : const Color(0xFF854D0E)))),
            )),
            DataCell(Text(r.assignedSchedule.isEmpty ? '—' : r.assignedSchedule, style: const TextStyle(fontSize: 13, color: kGray500))),
            DataCell(Row(mainAxisSize: MainAxisSize.min, children: _showArchived
              ? [Tooltip(message: 'Restore', child: IconButton(icon: const Icon(Icons.unarchive_outlined, size: 18, color: kGreen), onPressed: () => _unarchive(r.id))),
                 Tooltip(message: 'Delete', child: IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: kRed), onPressed: () => _delete(r.id)))]
              : [Tooltip(message: 'Edit', child: IconButton(icon: const Icon(Icons.edit_outlined, size: 18, color: kBlue), onPressed: () => _showModal(editing: r))),
                 Tooltip(message: 'Archive', child: IconButton(icon: const Icon(Icons.archive_outlined, size: 18, color: kGray500), onPressed: () => _archive(r.id))),
                 Tooltip(message: 'Delete', child: IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: kRed), onPressed: () => _delete(r.id)))]
            )),
          ])).toList(),
        )),
      ),
    ]));
  }

  Widget _statCard(String label, String value, Color color) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: kGray500)),
      const SizedBox(height: 6),
      Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: color)),
    ]),
  );
}
