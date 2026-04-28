// lib/pages/admin/admin_announcements.dart
import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/app_state.dart';
import '../../theme.dart';

class AdminAnnouncements extends StatefulWidget {
  const AdminAnnouncements({super.key, this.currentUserName = 'Administrator', this.currentUserRole = 'admin'});
  final String currentUserName;
  final String currentUserRole;
  @override
  State<AdminAnnouncements> createState() => _AdminAnnouncementsState();
}

class _AdminAnnouncementsState extends State<AdminAnnouncements> {
  final state = AppState();

  void _delete(int id) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Delete Announcement'),
      content: const Text('Are you sure you want to delete this announcement?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: kRed), onPressed: () { state.announcements.removeWhere((a) => a.id == id); Navigator.pop(context); setState(() {}); }, child: const Text('Delete')),
      ],
    ));
  }

  void _showCreateModal({Announcement? editing}) {
    final titleCtrl   = TextEditingController(text: editing?.title ?? '');
    final contentCtrl = TextEditingController(text: editing?.content ?? '');
    String audience = editing?.audience ?? 'All';
    final isEdit = editing != null;

    showDialog(context: context, builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => AlertDialog(
        title: Text(isEdit ? 'Edit Announcement' : 'Create Announcement', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: SizedBox(width: 460, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Title', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)),
          const SizedBox(height: 4),
          TextField(controller: titleCtrl, decoration: const InputDecoration(hintText: 'Announcement title', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), border: OutlineInputBorder(), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: kGray300)))),
          const SizedBox(height: 12),
          const Text('Content', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)),
          const SizedBox(height: 4),
          TextField(controller: contentCtrl, maxLines: 4, decoration: const InputDecoration(hintText: 'Write the announcement content here...', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), border: OutlineInputBorder(), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: kGray300)))),
          const SizedBox(height: 12),
          const Text('Target Audience', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)),
          const SizedBox(height: 4),
          Container(decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(value: audience, isExpanded: true, underline: const SizedBox(),
              items: ['All', 'Students', 'Instructors'].map((a) => DropdownMenuItem(value: a, child: Text(a, style: const TextStyle(fontSize: 13)))).toList(),
              onChanged: (v) => setS(() => audience = v!))),
        ]))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isEmpty || contentCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title and content are required.'), backgroundColor: kRed));
                return;
              }
              final now = DateTime.now();
              final dateStr = '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}';
              if (isEdit) {
                final idx = state.announcements.indexWhere((a) => a.id == editing.id);
                if (idx != -1) { state.announcements[idx].title = titleCtrl.text; state.announcements[idx].content = contentCtrl.text; state.announcements[idx].audience = audience; }
              } else {
                state.announcements.insert(0, Announcement(id: state.nextAnnouncementId++, title: titleCtrl.text, content: contentCtrl.text, audience: audience, author: widget.currentUserName, authorRole: widget.currentUserRole, datePosted: dateStr));
              }
              Navigator.pop(ctx); setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Announcement published successfully!'), backgroundColor: kGreen, duration: Duration(seconds: 2)));
            },
            child: Text(isEdit ? 'Update' : 'Publish'),
          ),
        ],
      ),
    ));
  }

  Color _audienceColor(String a) { if (a == 'Students') return kBlue; if (a == 'Instructors') return const Color(0xFF7C3AED); return kGreen; }
  Color _audienceBg(String a) { if (a == 'Students') return kBlueLight; if (a == 'Instructors') return const Color(0xFFEDE9FE); return kGreenLight; }

  @override
  Widget build(BuildContext context) {
    final announcements = state.announcements;

    return SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Announcements', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kGray900)),
          Text('Post and manage announcements for students and instructors', style: TextStyle(fontSize: 13, color: kGray500)),
        ])),
        ElevatedButton.icon(onPressed: () => _showCreateModal(), icon: const Icon(Icons.add, size: 16), label: const Text('Create Announcement')),
      ]),
      const SizedBox(height: 24),

      if (announcements.isEmpty)
        Container(padding: const EdgeInsets.all(40), decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)), child: const Center(child: Text('No announcements yet. Create one to get started.', style: TextStyle(fontSize: 14, color: kGray500))))
      else
        ...announcements.map((a) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kGray900)),
                const SizedBox(height: 4),
                Row(children: [
                  Text('By ${a.author}', style: const TextStyle(fontSize: 12, color: kGray500)),
                  const Text('  •  ', style: TextStyle(fontSize: 12, color: kGray400)),
                  Text(a.datePosted, style: const TextStyle(fontSize: 12, color: kGray500)),
                  const SizedBox(width: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: _audienceBg(a.audience), borderRadius: BorderRadius.circular(20)),
                    child: Text(a.audience, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _audienceColor(a.audience)))),
                ]),
              ])),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Tooltip(message: 'Edit', child: IconButton(icon: const Icon(Icons.edit_outlined, size: 18, color: kBlue), onPressed: () => _showCreateModal(editing: a))),
                Tooltip(message: 'Delete', child: IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: kRed), onPressed: () => _delete(a.id))),
              ]),
            ]),
            const SizedBox(height: 12),
            Text(a.content, style: const TextStyle(fontSize: 14, color: kGray700, height: 1.5)),
          ]),
        )),
    ]));
  }
}
