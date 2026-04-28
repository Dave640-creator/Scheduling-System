import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../models/app_state.dart';
import '../theme.dart';
import '../widgets/tcgc_logo.dart';
import 'login_page.dart';

class StudentDashboard extends StatefulWidget {
  final AppUser user;
  const StudentDashboard({super.key, required this.user});
  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _tab = 0; // 0=Schedule, 1=Announcements
  static const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  Widget build(BuildContext context) {
    final schedule = AppState.studentSchedule;
    final announcements = AppState()
        .announcements
        .where((a) => a.audience == 'All' || a.audience == 'Students')
        .toList();

    return Scaffold(
      backgroundColor: kGray50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          const TcgcLogoSmall(size: 38),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('TCGC – Student Portal',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kGray900)),
            Text('${widget.user.name}  •  ID: ${widget.user.idNumber}',
                style: const TextStyle(fontSize: 11, color: kGray500)),
          ]),
        ]),
        actions: [
          TextButton.icon(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false),
              icon: const Icon(Icons.logout, color: kGray700, size: 18),
              label: const Text('Logout',
                  style: TextStyle(color: kGray700, fontSize: 13)))
        ],
      ),
      body: Column(children: [
        // ── Tab bar ──────────────────────────────────────────────────────────
        Container(
          color: kWhite,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(children: [
            _tabBtn('My Schedule', Icons.calendar_month_outlined, 0),
            const SizedBox(width: 4),
            _tabBtn('Announcements', Icons.campaign_outlined, 1),
          ]),
        ),
        const Divider(height: 1, color: kGray200),
        Expanded(
            child: _tab == 0
                ? _buildScheduleTab(schedule)
                : _buildAnnouncementsTab(announcements)),
      ]),
    );
  }

  Widget _tabBtn(String label, IconData icon, int idx) => GestureDetector(
        onTap: () => setState(() => _tab = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: _tab == idx ? kGreen : Colors.transparent,
                      width: 2))),
          child: Row(children: [
            Icon(icon, size: 16, color: _tab == idx ? kGreen : kGray500),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        _tab == idx ? FontWeight.w600 : FontWeight.normal,
                    color: _tab == idx ? kGreen : kGray500)),
          ]),
        ),
      );

  // ── SCHEDULE TAB ──────────────────────────────────────────────────────────
  Widget _buildScheduleTab(List<Map<String, String>> schedule) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header info
        Row(children: [
          _infoChip(Icons.school_outlined, 'BS Computer Science', kBlue),
          const SizedBox(width: 8),
          _infoChip(Icons.grade_outlined, '3rd Year', const Color(0xFF7C3AED)),
          const SizedBox(width: 8),
          _infoChip(Icons.book_outlined, '${schedule.length} Subjects', kGreen),
        ]),
        const SizedBox(height: 20),

        // ── Day cards ─────────────────────────────────────────────────────
        const Text('Weekly Class Schedule',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: kGray900)),
        const SizedBox(height: 4),
        const Text('2nd Semester • Academic Year 2025–2026',
            style: TextStyle(fontSize: 12, color: kGray500)),
        const SizedBox(height: 16),

        ...(_days.map((day) {
          final classes = schedule.where((s) => s['day'] == day).toList();
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kGray200),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1))
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Day header
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: classes.isNotEmpty ? kGreen : kGray100,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(9),
                      topRight: Radius.circular(9)),
                ),
                child: Row(children: [
                  Icon(Icons.today,
                      size: 15, color: classes.isNotEmpty ? kWhite : kGray400),
                  const SizedBox(width: 8),
                  Text(day,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: classes.isNotEmpty ? kWhite : kGray400)),
                  const Spacer(),
                  if (classes.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                          '${classes.length} class${classes.length > 1 ? 'es' : ''}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: kWhite,
                              fontWeight: FontWeight.w600)),
                    ),
                ]),
              ),
              // Classes list
              if (classes.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  child: Row(children: [
                    Icon(Icons.event_busy_outlined, size: 16, color: kGray300),
                    SizedBox(width: 8),
                    Text('No classes scheduled',
                        style: TextStyle(
                            fontSize: 13,
                            color: kGray400,
                            fontStyle: FontStyle.italic)),
                  ]),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      children: classes.asMap().entries.map((e) {
                    final cls = e.value;
                    return Container(
                      //margin: const EdgeInsets.only(bottom: e.key < classes.length - 1 ? 8 : 0),
                      decoration: BoxDecoration(
                        color: kGray50,
                        border: Border.all(color: kGray200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IntrinsicHeight(
                        child: Row(children: [
                          // Time strip
                          Container(
                            width: 4,
                            decoration: BoxDecoration(
                                color: kGreen,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    bottomLeft: Radius.circular(7))),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Subject
                                    Text(cls['subject']!,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: kGray900)),
                                    const SizedBox(height: 6),
                                    // Details row
                                    Wrap(spacing: 16, runSpacing: 4, children: [
                                      _detail(Icons.access_time_outlined,
                                          cls['time']!),
                                      _detail(Icons.meeting_room_outlined,
                                          cls['room']!),
                                      _detail(Icons.person_outline,
                                          cls['instructor']!),
                                      _detail(Icons.menu_book_outlined,
                                          '${cls['units']} units'),
                                    ]),
                                  ]),
                            ),
                          ),
                        ]),
                      ),
                    );
                  }).toList()),
                ),
            ]),
          );
        }).toList()),

        // ── Summary table ─────────────────────────────────────────────────
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kGray200)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Enrolled Subjects Summary',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kGray900))),
            const Divider(height: 1, color: kGray200),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(kGray50),
                  columns: [
                    'Subject',
                    'Instructor',
                    'Room',
                    'Day',
                    'Time',
                    'Units'
                  ]
                      .map((h) => DataColumn(
                          label: Text(h,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: kGray500))))
                      .toList(),
                  rows: schedule
                      .map((s) => DataRow(cells: [
                            DataCell(Text(s['subject']!,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: kGray900))),
                            DataCell(Text(s['instructor']!,
                                style: const TextStyle(
                                    fontSize: 13, color: kGray700))),
                            DataCell(Text(s['room']!,
                                style: const TextStyle(
                                    fontSize: 13, color: kGray700))),
                            DataCell(Text(s['day']!,
                                style: const TextStyle(
                                    fontSize: 13, color: kGray700))),
                            DataCell(Text(s['time']!,
                                style: const TextStyle(
                                    fontSize: 13, color: kGray700))),
                            DataCell(Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: kGreenLight,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(s['units']!,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: kGreenDark)))),
                          ]))
                      .toList(),
                )),
          ]),
        ),
      ]),
    );
  }

  // ── ANNOUNCEMENTS TAB ─────────────────────────────────────────────────────
  Widget _buildAnnouncementsTab(List<Announcement> announcements) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Announcements',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: kGray900)),
        const SizedBox(height: 4),
        const Text('Latest news and updates from the institution',
            style: TextStyle(fontSize: 12, color: kGray500)),
        const SizedBox(height: 16),
        if (announcements.isEmpty)
          Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kGray200)),
              child: const Center(
                  child: Text('No announcements at this time.',
                      style: TextStyle(fontSize: 13, color: kGray500))))
        else
          ...announcements.map((a) => _announcementCard(a)),
      ]),
    );
  }

  Widget _announcementCard(Announcement a) {
    final audienceColor = a.audience == 'Students'
        ? kBlue
        : (a.audience == 'Instructors' ? const Color(0xFF7C3AED) : kGreen);
    final audienceBg = a.audience == 'Students'
        ? kBlueLight
        : (a.audience == 'Instructors' ? const Color(0xFFEDE9FE) : kGreenLight);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kGray200),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
              child: Text(a.title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kGray900))),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: audienceBg, borderRadius: BorderRadius.circular(20)),
              child: Text(a.audience,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: audienceColor))),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.person_outline, size: 13, color: kGray400),
          const SizedBox(width: 4),
          Text(a.author, style: const TextStyle(fontSize: 12, color: kGray500)),
          const Text('  •  ', style: TextStyle(color: kGray300)),
          const Icon(Icons.calendar_today_outlined, size: 12, color: kGray400),
          const SizedBox(width: 4),
          Text(a.datePosted,
              style: const TextStyle(fontSize: 12, color: kGray500)),
        ]),
        const SizedBox(height: 10),
        const Divider(height: 1, color: kGray100),
        const SizedBox(height: 10),
        Text(a.content,
            style: const TextStyle(fontSize: 13, color: kGray700, height: 1.6)),
      ]),
    );
  }

  Widget _detail(IconData icon, String text) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: kGray500),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: kGray700)),
      ]);

  Widget _infoChip(IconData icon, String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ]),
      );
}
