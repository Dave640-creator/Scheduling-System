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
  final _s = AppState();
  bool _showArchived = false;
  final _depts = ['Computer Science','Information Technology','Information Systems','Mathematics','Physics'];

  void _delete(int id) => showDialog(context: context, builder: (_) => AlertDialog(
    title: const Text('Delete Instructor'), content: const Text('Permanently remove this instructor?'),
    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: kRed), onPressed: () { _s.instructors.removeWhere((i) => i.id == id); Navigator.pop(context); setState(() {}); }, child: const Text('Delete'))],
  ));

  void _archive(int id) { final i = _s.instructors.indexWhere((x) => x.id == id); if (i != -1) { _s.instructors[i].status = 'Archived'; setState(() {}); } ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Instructor archived.'), backgroundColor: kGray700, duration: Duration(seconds: 2))); }
  void _restore(int id) { final i = _s.instructors.indexWhere((x) => x.id == id); if (i != -1) { _s.instructors[i].status = 'Active'; setState(() {}); } }

  void _showModal({Instructor? editing}) {
    final nc = TextEditingController(text: editing?.name  ?? '');
    final ec = TextEditingController(text: editing?.email ?? '');
    final pc = TextEditingController(text: editing?.phone ?? '');
    String dept   = editing?.department ?? _depts[0];
    String status = (editing?.status == 'Archived') ? 'Active' : (editing?.status ?? 'Active');
    final isEdit  = editing != null;
    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => AlertDialog(
      title: Text(isEdit ? 'Edit Instructor' : 'Add Instructor', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        _tf('Full Name', nc, 'e.g. Dr. Juan Dela Cruz'),
        const SizedBox(height: 10),
        _tf('Email', ec, 'e.g. instructor@tcgc.edu'),
        const SizedBox(height: 10),
        _tf('Phone', pc, 'e.g. +63 917 000 0000'),
        const SizedBox(height: 10),
        _dd('Department', dept, _depts, (v) => setS(() => dept = v!)),
        const SizedBox(height: 10),
        _dd('Status', status, ['Active','Inactive'], (v) => setS(() => status = v!)),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          if (nc.text.isEmpty || ec.text.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name and email are required.'), backgroundColor: kRed)); return; }
          if (isEdit) { final i = _s.instructors.indexWhere((x) => x.id == editing.id); if (i != -1) { _s.instructors[i].name = nc.text; _s.instructors[i].email = ec.text; _s.instructors[i].phone = pc.text; _s.instructors[i].department = dept; _s.instructors[i].status = status; } }
          else { _s.instructors.add(Instructor(id: _s.nextInstructorId++, name: nc.text, email: ec.text, phone: pc.text, department: dept, subjects: 0, status: status)); }
          Navigator.pop(ctx); setState(() {});
        }, child: Text(isEdit ? 'Update' : 'Save')),
      ],
    )));
  }

  Widget _tf(String label, TextEditingController c, String hint) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kGray700)), const SizedBox(height: 4),
    TextField(controller: c, decoration: InputDecoration(hintText: hint, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kGray300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: kGray300)))),
  ]);

  Widget _dd(String label, String val, List<String> items, ValueChanged<String?> cb) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kGray700)), const SizedBox(height: 4),
    Container(decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(value: val, isExpanded: true, underline: const SizedBox(), items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(), onChanged: cb)),
  ]);

  @override
  Widget build(BuildContext context) {
    final w        = MediaQuery.of(context).size.width;
    final isMobile = w < 640;
    final active   = _s.instructors.where((i) => i.status != 'Archived').toList();
    final archived = _s.instructors.where((i) => i.status == 'Archived').toList();
    final display  = _showArchived ? archived : active;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, children: [
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Instructor Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: kGray900)),
            Text('Manage instructor profiles and assignments', style: TextStyle(fontSize: 13, color: kGray500)),
          ]),
          Row(mainAxisSize: MainAxisSize.min, children: [
            TextButton.icon(onPressed: () => setState(() => _showArchived = !_showArchived), icon: Icon(_showArchived ? Icons.visibility_off : Icons.archive_outlined, size: 16), label: Text(_showArchived ? 'Active' : 'Archived')),
            const SizedBox(width: 6),
            ElevatedButton.icon(onPressed: () => _showModal(), icon: const Icon(Icons.add, size: 16), label: const Text('Add Instructor')),
          ]),
        ]),
        const SizedBox(height: 16),

        GridView.count(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 2 : 4, mainAxisSpacing: 10, crossAxisSpacing: 10,
          childAspectRatio: isMobile ? 1.8 : 2.2,
          children: [
            _stat('Total', '${active.length}', kGray900),
            _stat('Active', '${active.where((i) => i.status == 'Active').length}', kGreen),
            _stat('Subjects', '${active.fold(0, (s, i) => s + i.subjects)}', kBlue),
            _stat('Archived', '${archived.length}', kGray500),
          ],
        ),
        const SizedBox(height: 16),

        if (_showArchived) _banner('Showing archived instructors'),

        isMobile
          ? Column(children: display.map((i) => _mobileCard(i)).toList())
          : Container(
              decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(kGray50),
                  columns: ['Name','Contact','Department','Subjects','Status','Actions']
                      .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
                  rows: display.map((i) => DataRow(cells: [
                    DataCell(Text(i.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray900))),
                    DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(i.email, style: const TextStyle(fontSize: 12, color: kGray500)), Text(i.phone, style: const TextStyle(fontSize: 11, color: kGray400))])),
                    DataCell(Text(i.department, style: const TextStyle(fontSize: 12, color: kGray500))),
                    DataCell(Text('${i.subjects}', style: const TextStyle(fontSize: 13, color: kGray900))),
                    DataCell(_badge(i.status)),
                    DataCell(Row(mainAxisSize: MainAxisSize.min, children: _showArchived
                      ? [Tooltip(message: 'Restore', child: IconButton(icon: const Icon(Icons.unarchive_outlined, size: 18, color: kGreen), onPressed: () => _restore(i.id))),
                         Tooltip(message: 'Delete',  child: IconButton(icon: const Icon(Icons.delete_outline,    size: 18, color: kRed),   onPressed: () => _delete(i.id)))]
                      : [Tooltip(message: 'Edit',    child: IconButton(icon: const Icon(Icons.edit_outlined,     size: 18, color: kBlue),  onPressed: () => _showModal(editing: i))),
                         Tooltip(message: 'Archive', child: IconButton(icon: const Icon(Icons.archive_outlined,  size: 18, color: kGray500), onPressed: () => _archive(i.id))),
                         Tooltip(message: 'Delete',  child: IconButton(icon: const Icon(Icons.delete_outline,    size: 18, color: kRed),   onPressed: () => _delete(i.id)))])),
                  ])).toList(),
                ),
              ),
            ),
      ]),
    );
  }

  Widget _mobileCard(Instructor i) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        CircleAvatar(backgroundColor: kBlueLight, child: Text(i.name[0], style: const TextStyle(color: kBlue, fontWeight: FontWeight.w700))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(i.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kGray900), overflow: TextOverflow.ellipsis),
          Text(i.department, style: const TextStyle(fontSize: 11, color: kGray500)),
        ])),
        _badge(i.status),
      ]),
      const SizedBox(height: 6),
      Text(i.email, style: const TextStyle(fontSize: 12, color: kGray500)),
      const SizedBox(height: 10),
      Row(children: _showArchived ? [
        Expanded(child: ElevatedButton.icon(onPressed: () => _restore(i.id), icon: const Icon(Icons.unarchive_outlined, size: 14), label: const Text('Restore', style: TextStyle(fontSize: 12)))),
        const SizedBox(width: 8),
        Expanded(child: OutlinedButton.icon(onPressed: () => _delete(i.id), icon: const Icon(Icons.delete_outline, size: 14), label: const Text('Delete', style: TextStyle(fontSize: 12)), style: OutlinedButton.styleFrom(foregroundColor: kRed, side: const BorderSide(color: kRed)))),
      ] : [
        Expanded(child: OutlinedButton.icon(onPressed: () => _archive(i.id), icon: const Icon(Icons.archive_outlined, size: 14), label: const Text('Archive', style: TextStyle(fontSize: 12)), style: OutlinedButton.styleFrom(foregroundColor: kGray500))),
        const SizedBox(width: 8),
        Expanded(child: ElevatedButton.icon(onPressed: () => _showModal(editing: i), icon: const Icon(Icons.edit_outlined, size: 14), label: const Text('Edit', style: TextStyle(fontSize: 12)))),
      ]),
    ]),
  );

  Widget _badge(String s) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: s == 'Active' ? kGreenLight : kGray100, borderRadius: BorderRadius.circular(20)),
    child: Text(s, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: s == 'Active' ? kGreenDark : kGray700)),
  );

  Widget _stat(String l, String v, Color c) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    padding: const EdgeInsets.all(12),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(v, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: c)),
      Text(l, style: const TextStyle(fontSize: 11, color: kGray500)),
    ]),
  );

  Widget _banner(String msg) => Container(
    margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(color: kGray100, borderRadius: BorderRadius.circular(8)),
    child: Row(children: [const Icon(Icons.archive_outlined, size: 16, color: kGray500), const SizedBox(width: 8), Text(msg, style: const TextStyle(fontSize: 13, color: kGray500))]),
  );
}
