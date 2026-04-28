import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../models/app_state.dart';
import '../theme.dart';
import '../widgets/tcgc_logo.dart';
import 'login_page.dart';

class InstructorDashboard extends StatefulWidget {
  final AppUser user;
  const InstructorDashboard({super.key, required this.user});
  @override
  State<InstructorDashboard> createState() => _InstructorDashboardState();
}

class _InstructorDashboardState extends State<InstructorDashboard> {
  int _tab = 0; // 0=Schedule 1=Announcements 2=Reports
  static const _days = ['Monday','Tuesday','Wednesday','Thursday','Friday'];
  final _state = AppState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGray50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          const TcgcLogoSmall(size: 38), const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('TCGC – Instructor Portal', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900)),
            Text(widget.user.name, style: const TextStyle(fontSize: 11, color: kGray500)),
          ]),
        ]),
        actions: [TextButton.icon(
          onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false),
          icon: const Icon(Icons.logout, color: kGray700, size: 18),
          label: const Text('Logout', style: TextStyle(color: kGray700, fontSize: 13)))],
      ),
      body: Column(children: [
        // Tab bar
        Container(
          color: kWhite,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            _tabBtn('My Schedule',    Icons.calendar_month_outlined, 0),
            const SizedBox(width: 4),
            _tabBtn('Announcements',  Icons.campaign_outlined,       1),
            const SizedBox(width: 4),
            _tabBtn('Reports',        Icons.bar_chart_outlined,      2),
          ]),
        ),
        const Divider(height: 1, color: kGray200),
        Expanded(child: IndexedStack(index: _tab, children: [
          _buildScheduleTab(),
          _buildAnnouncementsTab(),
          _buildReportsTab(),
        ])),
      ]),
    );
  }

  Widget _tabBtn(String label, IconData icon, int idx) => GestureDetector(
    onTap: () => setState(() => _tab = idx),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: _tab == idx ? kGreen : Colors.transparent, width: 2))),
      child: Row(children: [
        Icon(icon, size: 15, color: _tab == idx ? kGreen : kGray500), const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: _tab == idx ? FontWeight.w600 : FontWeight.normal, color: _tab == idx ? kGreen : kGray500)),
      ]),
    ),
  );

  // ── SCHEDULE TAB ─────────────────────────────────────────────────────────
  Widget _buildScheduleTab() {
    final schedule = AppState.instructorSchedule;
    final totalStudents = schedule.fold(0, (s, c) => s + (c['students'] as int));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Stats
        Row(children: [
          Expanded(child: _statCard('Subjects',    '${schedule.length}', Icons.book_outlined,          kGreen)),
          const SizedBox(width: 12),
          Expanded(child: _statCard('Students',    '$totalStudents',     Icons.people_outline,          kBlue)),
          const SizedBox(width: 12),
          Expanded(child: _statCard('Teaching Days','2',                 Icons.calendar_month_outlined, const Color(0xFF7C3AED))),
        ]),
        const SizedBox(height: 20),

        const Text('Weekly Teaching Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kGray900)),
        const SizedBox(height: 4),
        const Text('2nd Semester • Academic Year 2025–2026', style: TextStyle(fontSize: 12, color: kGray500)),
        const SizedBox(height: 16),

        ...(_days.map((day) {
          final classes = schedule.where((s) => s['day'] == day).toList();
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)]),
            child: Column(children: [
              Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: classes.isNotEmpty ? const Color(0xFF2563EB) : kGray100,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
                ),
                child: Row(children: [
                  Icon(Icons.today, size: 14, color: classes.isNotEmpty ? kWhite : kGray400), const SizedBox(width: 8),
                  Text(day, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: classes.isNotEmpty ? kWhite : kGray400)),
                  const Spacer(),
                  if (classes.isNotEmpty) Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(20)),
                    child: Text('${classes.length} class${classes.length > 1 ? 'es' : ''}', style: const TextStyle(fontSize: 11, color: kWhite, fontWeight: FontWeight.w600))),
                ]),
              ),
              if (classes.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  child: Row(children: [Icon(Icons.event_busy_outlined, size: 16, color: kGray300), SizedBox(width: 8), Text('No classes scheduled', style: TextStyle(fontSize: 13, color: kGray400, fontStyle: FontStyle.italic))]),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(children: classes.asMap().entries.map((e) {
                    final cls = e.value;
                    return Container(
                      margin: EdgeInsets.only(bottom: e.key < classes.length - 1 ? 8 : 0),
                      decoration: BoxDecoration(color: kGray50, border: Border.all(color: kGray200), borderRadius: BorderRadius.circular(8)),
                      child: IntrinsicHeight(child: Row(children: [
                        Container(width: 4, decoration: const BoxDecoration(color: Color(0xFF2563EB), borderRadius: BorderRadius.only(topLeft: Radius.circular(7), bottomLeft: Radius.circular(7)))),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(cls['subject'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kGray900)),
                            const SizedBox(height: 6),
                            Wrap(spacing: 16, runSpacing: 4, children: [
                              _detail(Icons.access_time_outlined,  cls['time'] as String),
                              _detail(Icons.meeting_room_outlined, cls['room'] as String),
                              _detail(Icons.people_outline,        '${cls['students']} students'),
                            ]),
                          ]),
                        )),
                      ])),
                    );
                  }).toList()),
                ),
            ]),
          );
        }).toList()),

        // Summary table
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
          child: Column(children: [
            const Padding(padding: EdgeInsets.all(16), child: Align(alignment: Alignment.centerLeft, child: Text('Teaching Load Summary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kGray900)))),
            const Divider(height: 1, color: kGray200),
            SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
              headingRowColor: WidgetStateProperty.all(kGray50),
              columns: ['Subject','Room','Day','Time','Students']
                  .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kGray500)))).toList(),
              rows: schedule.map((s) => DataRow(cells: [
                DataCell(Text(s['subject'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900))),
                DataCell(Text(s['room']    as String, style: const TextStyle(fontSize: 13, color: kGray700))),
                DataCell(Text(s['day']     as String, style: const TextStyle(fontSize: 13, color: kGray700))),
                DataCell(Text(s['time']    as String, style: const TextStyle(fontSize: 13, color: kGray700))),
                DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: kBlueLight, borderRadius: BorderRadius.circular(20)), child: Text('${s['students']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kBlue)))),
              ])).toList(),
            )),
          ]),
        ),
      ]),
    );
  }

  // ── ANNOUNCEMENTS TAB ────────────────────────────────────────────────────
  Widget _buildAnnouncementsTab() {
    return StatefulBuilder(builder: (ctx, setS) {
      final all = _state.announcements.where((a) => a.audience == 'All' || a.audience == 'Instructors').toList();
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Announcements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kGray900)),
              Text('Institutional news and updates', style: TextStyle(fontSize: 12, color: kGray500)),
            ])),
            ElevatedButton.icon(
              onPressed: () => _showCreateAnnouncement(setS),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Create'),
            ),
          ]),
          const SizedBox(height: 16),
          if (all.isEmpty)
            Container(padding: const EdgeInsets.all(32), decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
              child: const Center(child: Text('No announcements at this time.', style: TextStyle(fontSize: 13, color: kGray500))))
          else
            ...all.map((a) => _announcementCard(a)),
        ]),
      );
    });
  }

  void _showCreateAnnouncement(StateSetter setS) {
    final titleCtrl   = TextEditingController();
    final contentCtrl = TextEditingController();
    String audience   = 'All';
    showDialog(context: context, builder: (ctx) => StatefulBuilder(
      builder: (ctx, setD) => AlertDialog(
        title: const Text('Create Announcement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: SizedBox(width: double.maxFinite, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Title', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)), const SizedBox(height: 4),
          TextField(controller: titleCtrl, decoration: const InputDecoration(hintText: 'Announcement title', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
          const SizedBox(height: 12),
          const Text('Content', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)), const SizedBox(height: 4),
          TextField(controller: contentCtrl, maxLines: 4, decoration: const InputDecoration(hintText: 'Write the content here...', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10))),
          const SizedBox(height: 12),
          const Text('Target Audience', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)), const SizedBox(height: 4),
          Container(decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(value: audience, isExpanded: true, underline: const SizedBox(),
              items: ['All','Students','Instructors'].map((a) => DropdownMenuItem(value: a, child: Text(a, style: const TextStyle(fontSize: 13)))).toList(),
              onChanged: (v) => setD(() => audience = v!))),
        ]))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isEmpty || contentCtrl.text.isEmpty) return;
              final now = DateTime.now();
              _state.announcements.insert(0, Announcement(
                id: _state.nextAnnouncementId++, title: titleCtrl.text, content: contentCtrl.text,
                audience: audience, author: widget.user.name, authorRole: 'instructor',
                datePosted: '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}'));
              Navigator.pop(ctx); setS(() {});
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Announcement published!'), backgroundColor: kGreen, duration: Duration(seconds: 2)));
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    ));
  }

  // ── REPORTS TAB ──────────────────────────────────────────────────────────
  Widget _buildReportsTab() {
    final reportTypes = ['Schedule Coverage Report','Instructor Workload Report','Conflict Summary Report','Room Utilization Report'];
    final terms       = ['2nd Semester 2025-2026','1st Semester 2025-2026','2nd Semester 2024-2025'];

    return StatefulBuilder(builder: (ctx, setS) {
      final myReports = _state.reports.where((r) => r.generatedBy == widget.user.name).toList();
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Reports', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kGray900)),
              Text('Generate and view system reports', style: TextStyle(fontSize: 12, color: kGray500)),
            ])),
            ElevatedButton.icon(
              onPressed: () {
                String selType = reportTypes[0];
                String selTerm = terms[0];
                showDialog(context: context, builder: (ctx) => StatefulBuilder(
                  builder: (ctx, setD) => AlertDialog(
                    title: const Text('Create Report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      _dropdownField('Report Type', selType, reportTypes, (v) => setD(() => selType = v!)),
                      const SizedBox(height: 12),
                      _dropdownField('Academic Term', selTerm, terms, (v) => setD(() => selTerm = v!)),
                    ]),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () {
                          final now = DateTime.now();
                          _state.reports.insert(0, Report(id: _state.nextReportId++, type: selType, term: selTerm,
                            dateGenerated: '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}',
                            generatedBy: widget.user.name));
                          Navigator.pop(ctx); setS(() {});
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report generated!'), backgroundColor: kGreen, duration: Duration(seconds: 2)));
                        },
                        child: const Text('Generate'),
                      ),
                    ],
                  ),
                ));
              },
              icon: const Icon(Icons.add, size: 16), label: const Text('Create Report'),
            ),
          ]),
          const SizedBox(height: 20),

          // All reports (instructor can see all)
          Container(
            decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
            child: Column(children: [
              const Padding(padding: EdgeInsets.all(16), child: Align(alignment: Alignment.centerLeft, child: Text('Generated Reports', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kGray900)))),
              const Divider(height: 1, color: kGray200),
              if (_state.reports.isEmpty)
                const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No reports yet.', style: TextStyle(fontSize: 13, color: kGray500))))
              else
                ..._state.reports.map((r) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kGray100, width: 0.5))),
                  child: Row(children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: kBlueLight, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.description_outlined, size: 18, color: kBlue)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(r.type, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kGray900)),
                      const SizedBox(height: 2),
                      Text('${r.term}  •  ${r.dateGenerated}  •  By ${r.generatedBy}', style: const TextStyle(fontSize: 12, color: kGray500)),
                    ])),
                    IconButton(icon: const Icon(Icons.download_outlined, size: 18, color: kBlue), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download — connect to backend to export.'), duration: Duration(seconds: 2)))),
                  ]),
                )),
            ]),
          ),
        ]),
      );
    });
  }

  Widget _dropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kGray700)), const SizedBox(height: 4),
      Container(decoration: BoxDecoration(border: Border.all(color: kGray300), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButton<String>(value: value, isExpanded: true, underline: const SizedBox(), items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(), onChanged: onChanged)),
    ]);

  Widget _announcementCard(Announcement a) {
    final ac = a.audience == 'Students' ? kBlue : (a.audience == 'Instructors' ? const Color(0xFF7C3AED) : kGreen);
    final ab = a.audience == 'Students' ? kBlueLight : (a.audience == 'Instructors' ? const Color(0xFFEDE9FE) : kGreenLight);
    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(a.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kGray900))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: ab, borderRadius: BorderRadius.circular(20)), child: Text(a.audience, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ac))),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.person_outline, size: 13, color: kGray400), const SizedBox(width: 4),
          Text(a.author, style: const TextStyle(fontSize: 12, color: kGray500)),
          const Text('  •  ', style: TextStyle(color: kGray300)),
          Text(a.datePosted, style: const TextStyle(fontSize: 12, color: kGray500)),
        ]),
        const SizedBox(height: 10), const Divider(height: 1, color: kGray100), const SizedBox(height: 10),
        Text(a.content, style: const TextStyle(fontSize: 13, color: kGray700, height: 1.6)),
      ]),
    );
  }

  Widget _detail(IconData icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 13, color: kGray500), const SizedBox(width: 4),
    Text(text, style: const TextStyle(fontSize: 12, color: kGray700)),
  ]);

  Widget _statCard(String label, String value, IconData icon, Color color) => Container(
    decoration: BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGray200)),
    padding: const EdgeInsets.all(14),
    child: Row(children: [
      Container(width: 42, height: 42, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: kWhite, size: 20)), const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: kGray900)),
        Text(label, style: const TextStyle(fontSize: 11, color: kGray500)),
      ]),
    ]),
  );
}
