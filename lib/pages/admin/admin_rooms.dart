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

  void _delete(int id) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Delete Room'),
      content: const Text('Are you sure you want to delete this room?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: kRed), onPressed: () { state.rooms.removeWhere((r) => r.id == id); Navigator.pop(context); setState(() {}); }, child: const Text('Delete')),
      ],
    ));
  }

  void _showAddModal() {
    final nameCtrl = TextEditingController();
    final capCtrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Add New Room'),
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
            state.rooms.add(Room(id: state.nextRoomId++, name: nameCtrl.text, capacity: int.tryParse(capCtrl.text) ?? 0, status: 'Available'));
            Navigator.pop(context); setState(() {});
          },
          child: const Text('Add Room'),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final avail = state.rooms.where((r) => r.status == 'Available').length;
    final occ = state.rooms.where((r) => r.status == 'Occupied').length;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Room Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
            Text('Manage classroom and facility availability', style: TextStyle(fontSize: 13, color: kGray500)),
          ])),
          ElevatedButton.icon(onPressed: _showAddModal, icon: const Icon(Icons.add, size: 16), label: const Text('Add Room')),
        ]),
        const SizedBox(height: 20),
        LayoutBuilder(builder: (ctx, c) => GridView.count(
          crossAxisCount: c.maxWidth > 500 ? 3 : 1, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 2.5,
          children: [
            _statCard('Total Rooms', '${state.rooms.length}', kGray900),
            _statCard('Available', '$avail', kGreen),
            _statCard('Occupied', '$occ', kYellow),
          ],
        )),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
          child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
            headingRowColor: WidgetStateProperty.all(kGray50),
            columns: ['Room Name', 'Capacity', 'Status', 'Assigned Schedule', 'Actions']
              .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
            rows: state.rooms.map((r) => DataRow(cells: [
              DataCell(Text(r.name, style: const TextStyle(fontSize: 13, color: kGray900))),
              DataCell(Text('${r.capacity} students', style: const TextStyle(fontSize: 13, color: kGray500))),
              DataCell(Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: r.status == 'Available' ? kGreenLight : kYellowLight, borderRadius: BorderRadius.circular(20)),
                child: Text(r.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: r.status == 'Available' ? kGreenDark : const Color(0xFF854D0E))),
              )),
              DataCell(Text(r.assignedSchedule.isEmpty ? '—' : r.assignedSchedule, style: const TextStyle(fontSize: 13, color: kGray500))),
              DataCell(IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: kRed), onPressed: () => _delete(r.id))),
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
