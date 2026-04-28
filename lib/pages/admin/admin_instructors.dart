// lib/pages/admin/admin_instructors.dart
import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/app_state.dart';
import '../../theme.dart';

class AdminInstructors extends StatefulWidget {
  const AdminInstructors({super.key});
  @override
  State<AdminInstructors> createState() => _AdminInstructorsState();
}

class _AdminInstructorsState extends State<AdminInstructors> {
  final state = AppState();
  bool _showArchived = false;

  final departments = ['Computer Science', 'Information Technology', 'Information Systems', 'Mathematics', 'Physics'];

  void _delete(int id) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Delete Instructor'),
      content: const Text('Are you sure? This will permanently remove the instructor record.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: kRed), onPressed: () { state.instructors.removeWhere((i) => i.id == id); Navigator.pop(context); setState(() {}); }, child: const Text('Delete')),
      ],
    ));
  }

  void _archive(int id) {
    final idx = state.instructors.indexWhere((i) => i.id == id);
    if (idx != -1) { state.instructors[idx].status = 'Archived'; setState(() {}); }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Instructor archived.'), backgroundColor: kGray700, duration: Duration(seconds: 2)));
  }

  void _restore(int id) {
    final idx = state.instructors.indexWhere((i) => i.id == id);
    if (idx != -1) { state.instructors[idx].status = 'Active'; setState(() {}); }
  }

  void _showModal({Instructor? editing}) {
    final nameCtrl  = TextEditingController(text: editing?.name ?? '');
    final emailCtrl = TextEditingController(text: editing?.email ?? '');
    final phoneCtrl = TextEditingController(text: editing?.phone ?? '');
    String dept   = editing?.department ?? departments[0];
    String status = (editing?.status == 'Archived') ? 'Active' : (editing?.status ?? 'Active');
    final isEdit = editing != null;

    showDialog(context: context, builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => AlertDialog(
        title: Text(isEdit ? 'Edit Instructor' : 'Add Instructor', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          _field('Full Name', nameCtrl, 'e.g. Dr. Juan Dela Cruz'),
          const SizedBox(height: 12),
          _field('Email', emailCtrl, 'e.g. instructor@tcgc.edu'),
          const SizedBox(height: 12),
          _field('Phone', phoneCtrl, 'e.g. +63 917 000 0000'),
          const SizedBox(height: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Department', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)),
            const SizedBox(height: 4),
            Container(decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(value: dept, isExpanded: true, underline: const SizedBox(), items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 13)))).toList(), onChanged: (v) => setS(() => dept = v!))),
          ]),
          const SizedBox(height: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Status', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)),
            const SizedBox(height: 4),
            Container(decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(value: status, isExpanded: true, underline: const SizedBox(), items: ['Active', 'Inactive'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(), onChanged: (v) => setS(() => status = v!))),
          ]),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty || emailCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all required fields.'), backgroundColor: kRed));
                return;
              }
              if (isEdit) {
                final idx = state.instructors.indexWhere((i) => i.id == editing.id);
                if (idx != -1) { state.instructors[idx].name = nameCtrl.text; state.instructors[idx].email = emailCtrl.text; state.instructors[idx].phone = phoneCtrl.text; state.instructors[idx].department = dept; state.instructors[idx].status = status; }
              } else {
                state.instructors.add(Instructor(id: state.nextInstructorId++, name: nameCtrl.text, email: emailCtrl.text, phone: phoneCtrl.text, department: dept, subjects: 0, status: status));
              }
              Navigator.pop(ctx); setState(() {});
            },
            child: Text(isEdit ? 'Update' : 'Save'),
          ),
        ],
      ),
    ));
  }

  Widget _field(String label, TextEditingController ctrl, String hint) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)),
      const SizedBox(height: 4),
      TextField(controller: ctrl, decoration: InputDecoration(hintText: hint, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kGray300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kGray300)))),
    ]);

  @override
  Widget build(BuildContext context) {
    final active   = state.instructors.where((i) => i.status != 'Archived').toList();
    final archived = state.instructors.where((i) => i.status == 'Archived').toList();
    final display  = _showArchived ? archived : active;
    final totalSubs = active.fold(0, (s, i) => s + i.subjects);

    return SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Instructor Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
          const Text('Manage instructor profiles and assignments', style: TextStyle(fontSize: 13, color: kGray500)),
        ])),
        TextButton.icon(onPressed: () => setState(() => _showArchived = !_showArchived), icon: Icon(_showArchived ? Icons.visibility_off : Icons.archive_outlined, size: 16), label: Text(_showArchived ? 'Hide Archived' : 'View Archived')),
        const SizedBox(width: 8),
        ElevatedButton.icon(onPressed: () => _showModal(), icon: const Icon(Icons.add, size: 16), label: const Text('Add Instructor')),
      ]),
      const SizedBox(height: 20),

      Row(children: [
        Expanded(child: _stat('Total Instructors', '${active.length}', kGray900)),
        const SizedBox(width: 12),
        Expanded(child: _stat('Active', '${active.where((i) => i.status == 'Active').length}', kGreen)),
        const SizedBox(width: 12),
        Expanded(child: _stat('Total Subjects', '$totalSubs', kBlue)),
        const SizedBox(width: 12),
        Expanded(child: _stat('Archived', '${archived.length}', kGray500)),
      ]),
      const SizedBox(height: 20),

      if (_showArchived)
        Padding(padding: const EdgeInsets.only(bottom: 12), child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: kGray100, borderRadius: BorderRadius.circular(8)), child: const Row(children: [Icon(Icons.archive_outlined, size: 16, color: kGray500), SizedBox(width: 8), Text('Showing archived instructors', style: TextStyle(fontSize: 13, color: kGray500))]))),

      Container(
        decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
        child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
          headingRowColor: WidgetStateProperty.all(kGray50),
          columns: ['Name', 'Contact', 'Department', 'Subjects', 'Status', 'Actions']
              .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
          rows: display.map((i) => DataRow(cells: [
            DataCell(Text(i.name, style: const TextStyle(fontSize: 13, color: kGray900))),
            DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(i.email, style: const TextStyle(fontSize: 12, color: kGray500)),
              Text(i.phone, style: const TextStyle(fontSize: 12, color: kGray500)),
            ])),
            DataCell(Text(i.department, style: const TextStyle(fontSize: 13, color: kGray500))),
            DataCell(Text('${i.subjects} subject(s)', style: const TextStyle(fontSize: 13, color: kGray900))),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: i.status == 'Active' ? kGreenLight : kGray100, borderRadius: BorderRadius.circular(20)),
              child: Text(i.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: i.status == 'Active' ? kGreenDark : kGray700)),
            )),
            DataCell(Row(mainAxisSize: MainAxisSize.min, children: _showArchived
              ? [Tooltip(message: 'Restore', child: IconButton(icon: const Icon(Icons.unarchive_outlined, size: 18, color: kGreen), onPressed: () => _restore(i.id))),
                 Tooltip(message: 'Delete', child: IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: kRed), onPressed: () => _delete(i.id)))]
              : [Tooltip(message: 'Edit', child: IconButton(icon: const Icon(Icons.edit_outlined, size: 18, color: kBlue), onPressed: () => _showModal(editing: i))),
                 Tooltip(message: 'Archive', child: IconButton(icon: const Icon(Icons.archive_outlined, size: 18, color: kGray500), onPressed: () => _archive(i.id))),
                 Tooltip(message: 'Delete', child: IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: kRed), onPressed: () => _delete(i.id)))]
            )),
          ])).toList(),
        )),
      ),
    ]));
  }

  Widget _stat(String label, String value, Color color) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, color: kGray500)),
      const SizedBox(height: 6),
      Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: color)),
    ]),
  );
}
