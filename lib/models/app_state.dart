import 'app_models.dart';

class AppState {
  static final AppState _i = AppState._internal();
  factory AppState() => _i;
  AppState._internal();

  // ── USERS ─────────────────────────────────────────────────────────────────
  List<AppUser> users = [
    AppUser(email: 'admin@tcgc.edu',      password: 'admin123', role: 'admin',      idNumber: '000001', name: 'Administrator'),
    AppUser(email: 'instructor@tcgc.edu', password: 'inst123',  role: 'instructor', idNumber: '000002', name: 'Dr. Maria Santos'),
    AppUser(email: 'student@tcgc.edu',    password: 'stud123',  role: 'student',    idNumber: '000003', name: 'Juan Dela Cruz'),
  ];

  AppUser? login(String emailOrId, String password) {
    for (final u in users) {
      if ((u.email == emailOrId || u.idNumber == emailOrId) && u.password == password) return u;
    }
    return null;
  }

  // ── SCHEDULES ─────────────────────────────────────────────────────────────
  List<Schedule> schedules = [
    Schedule(id:1,  subject:'Data Structures',        instructor:'Dr. Santos',   room:'Room 301', day:'Monday',    time:'8:00 AM - 10:00 AM'),
    Schedule(id:2,  subject:'Web Development',        instructor:'Prof. Cruz',   room:'Room 302', day:'Monday',    time:'10:00 AM - 12:00 PM'),
    Schedule(id:3,  subject:'Database Systems',       instructor:'Dr. Santos',   room:'Room 303', day:'Monday',    time:'8:00 AM - 10:00 AM', hasConflict:true, conflictType:'Instructor schedule conflict'),
    Schedule(id:4,  subject:'Mobile App Dev',         instructor:'Prof. Garcia', room:'Room 301', day:'Tuesday',   time:'2:00 PM - 4:00 PM'),
    Schedule(id:5,  subject:'System Analysis',        instructor:'Dr. Lopez',    room:'Room 301', day:'Tuesday',   time:'2:00 PM - 4:00 PM', hasConflict:true, conflictType:'Room already occupied'),
    Schedule(id:6,  subject:'Computer Networks',      instructor:'Prof. Martinez',room:'Room 304',day:'Wednesday', time:'1:00 PM - 3:00 PM'),
    Schedule(id:7,  subject:'Software Engineering',   instructor:'Dr. Reyes',    room:'Room 305', day:'Thursday',  time:'9:00 AM - 11:00 AM'),
    Schedule(id:8,  subject:'Algorithms',             instructor:'Dr. Santos',   room:'Room 302', day:'Friday',    time:'3:00 PM - 5:00 PM'),
    Schedule(id:9,  subject:'Object Oriented Prog',   instructor:'Prof. Cruz',   room:'Room 306', day:'Tuesday',   time:'8:00 AM - 10:00 AM'),
    Schedule(id:10, subject:'Discrete Mathematics',   instructor:'Dr. Lopez',    room:'Room 307', day:'Wednesday', time:'9:00 AM - 11:00 AM'),
    Schedule(id:11, subject:'Operating Systems',      instructor:'Prof. Garcia', room:'Lab 201',  day:'Thursday',  time:'1:00 PM - 3:00 PM'),
    Schedule(id:12, subject:'Programming Lab',        instructor:'Prof. Martinez',room:'Lab 202', day:'Friday',    time:'8:00 AM - 10:00 AM'),
  ];
  int nextScheduleId = 13;

  // ── ROOMS ─────────────────────────────────────────────────────────────────
  List<Room> rooms = [
    Room(id:1,  name:'Room 301', capacity:40, status:'Occupied',  assignedSchedule:'Data Structures - Mon 8:00 AM'),
    Room(id:2,  name:'Room 302', capacity:35, status:'Occupied',  assignedSchedule:'Web Development - Mon 10:00 AM'),
    Room(id:3,  name:'Room 303', capacity:30, status:'Occupied',  assignedSchedule:'Database Systems - Mon 8:00 AM'),
    Room(id:4,  name:'Room 304', capacity:45, status:'Occupied',  assignedSchedule:'Computer Networks - Wed 1:00 PM'),
    Room(id:5,  name:'Room 305', capacity:40, status:'Occupied',  assignedSchedule:'Software Engineering - Thu 9:00 AM'),
    Room(id:6,  name:'Room 306', capacity:30, status:'Occupied',  assignedSchedule:'OOP - Tue 8:00 AM'),
    Room(id:7,  name:'Room 307', capacity:35, status:'Occupied',  assignedSchedule:'Discrete Math - Wed 9:00 AM'),
    Room(id:8,  name:'Lab 201',  capacity:25, status:'Occupied',  assignedSchedule:'Operating Systems - Thu 1:00 PM'),
    Room(id:9,  name:'Lab 202',  capacity:25, status:'Occupied',  assignedSchedule:'Programming Lab - Fri 8:00 AM'),
    Room(id:10, name:'Conference Hall', capacity:100, status:'Available'),
    Room(id:11, name:'Room 308', capacity:35, status:'Available'),
    Room(id:12, name:'Room 309', capacity:35, status:'Available'),
  ];
  int nextRoomId = 13;

  // ── PENDING ACCOUNTS ──────────────────────────────────────────────────────
  List<PendingAccount> accounts = [
    PendingAccount(id:1, name:'Maria Santos',  email:'maria.santos@tcgc.edu',  role:'Instructor', status:'Pending',  dateSubmitted:'2026-04-22'),
    PendingAccount(id:2, name:'John Cruz',     email:'john.cruz@tcgc.edu',     role:'Student',    status:'Pending',  dateSubmitted:'2026-04-22'),
    PendingAccount(id:3, name:'Ana Lopez',     email:'ana.lopez@tcgc.edu',     role:'Student',    status:'Pending',  dateSubmitted:'2026-04-21'),
    PendingAccount(id:4, name:'Robert Garcia', email:'robert.garcia@tcgc.edu', role:'Instructor', status:'Pending',  dateSubmitted:'2026-04-21'),
    PendingAccount(id:5, name:'Lisa Martinez', email:'lisa.martinez@tcgc.edu', role:'Student',    status:'Pending',  dateSubmitted:'2026-04-20'),
    PendingAccount(id:6, name:'Carlos Reyes',  email:'carlos.reyes@tcgc.edu',  role:'Student',    status:'Approved', dateSubmitted:'2026-04-19'),
    PendingAccount(id:7, name:'Nina Torres',   email:'nina.torres@tcgc.edu',   role:'Instructor', status:'Approved', dateSubmitted:'2026-04-18'),
    PendingAccount(id:8, name:'Ben Villanueva',email:'ben.v@tcgc.edu',         role:'Student',    status:'Rejected', dateSubmitted:'2026-04-17'),
  ];

  // ── INSTRUCTORS ───────────────────────────────────────────────────────────
  List<Instructor> instructors = [
    Instructor(id:1, name:'Dr. Maria Santos',   email:'m.santos@tcgc.edu',   phone:'+63 917 111 0001', department:'Computer Science',     subjects:3, status:'Active'),
    Instructor(id:2, name:'Prof. John Cruz',    email:'j.cruz@tcgc.edu',     phone:'+63 917 111 0002', department:'Computer Science',     subjects:2, status:'Active'),
    Instructor(id:3, name:'Dr. Ana Lopez',      email:'a.lopez@tcgc.edu',    phone:'+63 917 111 0003', department:'Information Technology',subjects:2, status:'Active'),
    Instructor(id:4, name:'Prof. Robert Garcia',email:'r.garcia@tcgc.edu',   phone:'+63 917 111 0004', department:'Computer Science',     subjects:2, status:'Active'),
    Instructor(id:5, name:'Prof. Martinez',     email:'c.martinez@tcgc.edu', phone:'+63 917 111 0005', department:'Information Systems',  subjects:2, status:'Active'),
    Instructor(id:6, name:'Dr. Reyes',          email:'d.reyes@tcgc.edu',    phone:'+63 917 111 0006', department:'Computer Science',     subjects:1, status:'Active'),
    Instructor(id:7, name:'Prof. Torres',       email:'p.torres@tcgc.edu',   phone:'+63 917 111 0007', department:'Information Technology',subjects:1, status:'Inactive'),
  ];
  int nextInstructorId = 8;

  // ── STUDENTS ──────────────────────────────────────────────────────────────
  static const List<Student> students = [
    Student(studentId:'2024-001', name:'Juan Dela Cruz',   email:'juan.dc@tcgc.edu',     program:'BS Computer Science',      yearLevel:'3rd Year', status:'Active'),
    Student(studentId:'2024-002', name:'Maria Clara',      email:'maria.c@tcgc.edu',     program:'BS Information Technology',yearLevel:'2nd Year', status:'Active'),
    Student(studentId:'2024-003', name:'Pedro Santos',     email:'pedro.s@tcgc.edu',     program:'BS Computer Science',      yearLevel:'4th Year', status:'Active'),
    Student(studentId:'2024-004', name:'Ana Reyes',        email:'ana.r@tcgc.edu',        program:'BS Information Systems',  yearLevel:'1st Year', status:'Active'),
    Student(studentId:'2024-005', name:'Carlos Lopez',     email:'carlos.l@tcgc.edu',    program:'BS Computer Science',      yearLevel:'2nd Year', status:'Active'),
    Student(studentId:'2024-006', name:'Lisa Garcia',      email:'lisa.g@tcgc.edu',      program:'BS Information Technology',yearLevel:'3rd Year', status:'Active'),
    Student(studentId:'2024-007', name:'Robert Martinez',  email:'robert.m@tcgc.edu',    program:'BS Computer Science',      yearLevel:'1st Year', status:'Active'),
    Student(studentId:'2024-008', name:'Nina Torres',      email:'nina.t@tcgc.edu',      program:'BS Information Systems',  yearLevel:'2nd Year', status:'Inactive'),
    Student(studentId:'2024-009', name:'Jose Ramos',       email:'jose.r@tcgc.edu',      program:'BS Information Technology',yearLevel:'4th Year', status:'Active'),
    Student(studentId:'2024-010', name:'Carmen Cruz',      email:'carmen.c@tcgc.edu',    program:'BS Computer Science',      yearLevel:'3rd Year', status:'Active'),
    Student(studentId:'2024-011', name:'Miguel Bautista',  email:'miguel.b@tcgc.edu',    program:'BS Computer Science',      yearLevel:'1st Year', status:'Active'),
    Student(studentId:'2024-012', name:'Sofia Mendoza',    email:'sofia.m@tcgc.edu',     program:'BS Information Technology',yearLevel:'2nd Year', status:'Active'),
  ];

  // ── STUDENT SCHEDULE (sample enrolled) ───────────────────────────────────
  static const List<Map<String,String>> studentSchedule = [
    {'subject':'Data Structures',      'instructor':'Dr. Santos',    'room':'Room 301', 'day':'Monday',    'time':'8:00 AM - 10:00 AM',  'units':'3'},
    {'subject':'Web Development',      'instructor':'Prof. Cruz',    'room':'Room 302', 'day':'Monday',    'time':'10:00 AM - 12:00 PM', 'units':'3'},
    {'subject':'Mobile App Dev',       'instructor':'Prof. Garcia',  'room':'Room 301', 'day':'Tuesday',   'time':'2:00 PM - 4:00 PM',   'units':'3'},
    {'subject':'Computer Networks',    'instructor':'Prof. Martinez','room':'Room 304', 'day':'Wednesday', 'time':'1:00 PM - 3:00 PM',   'units':'3'},
    {'subject':'Software Engineering', 'instructor':'Dr. Reyes',     'room':'Room 305', 'day':'Thursday',  'time':'9:00 AM - 11:00 AM',  'units':'3'},
    {'subject':'Algorithms',           'instructor':'Dr. Santos',    'room':'Room 302', 'day':'Friday',    'time':'3:00 PM - 5:00 PM',   'units':'3'},
  ];

  // ── INSTRUCTOR SCHEDULE ───────────────────────────────────────────────────
  static const List<Map<String,dynamic>> instructorSchedule = [
    {'subject':'Data Structures',      'room':'Room 301', 'day':'Monday',    'time':'8:00 AM - 10:00 AM',  'students':35},
    {'subject':'Database Systems',     'room':'Room 303', 'day':'Monday',    'time':'8:00 AM - 10:00 AM',  'students':30},
    {'subject':'Algorithms',           'room':'Room 302', 'day':'Friday',    'time':'3:00 PM - 5:00 PM',   'students':32},
  ];

  // ── ANNOUNCEMENTS ─────────────────────────────────────────────────────────
  List<Announcement> announcements = [
    Announcement(id:1, title:'Enrollment Period Open',       content:'Enrollment for the 2nd semester is now open. Please coordinate with your respective instructors for schedule assignments. Deadline is May 15, 2026.',  audience:'All',         author:'Administrator',    authorRole:'admin',      datePosted:'2026-04-20'),
    Announcement(id:2, title:'Faculty Meeting – May 5',      content:'All instructors are required to attend the faculty meeting on May 5, 2026 at 2:00 PM in the Conference Hall. Attendance is mandatory.',               audience:'Instructors',   author:'Administrator',    authorRole:'admin',      datePosted:'2026-04-22'),
    Announcement(id:3, title:'Final Exam Schedule Released', content:'The final examination schedule for all subjects has been released. Please check your respective portals for your assigned rooms and time slots.',        audience:'Students',      author:'Dr. Maria Santos', authorRole:'instructor', datePosted:'2026-04-25'),
    Announcement(id:4, title:'No Classes – May 1 (Labor Day)',content:'In observance of Labor Day, there will be no classes on May 1, 2026. Classes will resume on May 2, 2026.',                                           audience:'All',           author:'Administrator',    authorRole:'admin',      datePosted:'2026-04-26'),
    Announcement(id:5, title:'Reminder: Submit Term Papers',  content:'All students enrolled in Software Engineering are reminded to submit their term papers no later than May 3, 2026. Late submissions will not be accepted.',audience:'Students',     author:'Dr. Reyes',        authorRole:'instructor', datePosted:'2026-04-27'),
  ];
  int nextAnnouncementId = 6;

  // ── REPORTS ───────────────────────────────────────────────────────────────
  List<Report> reports = [
    Report(id:1, type:'Room Utilization Report',    term:'1st Semester 2025-2026', dateGenerated:'2026-04-01', generatedBy:'Administrator'),
    Report(id:2, type:'Instructor Workload Report', term:'1st Semester 2025-2026', dateGenerated:'2026-04-01', generatedBy:'Administrator'),
    Report(id:3, type:'Conflict Summary Report',    term:'2nd Semester 2025-2026', dateGenerated:'2026-04-25', generatedBy:'Administrator'),
    Report(id:4, type:'Schedule Coverage Report',   term:'2nd Semester 2025-2026', dateGenerated:'2026-04-27', generatedBy:'Dr. Maria Santos'),
  ];
  int nextReportId = 5;

  // ── CONFLICT DETECTION ────────────────────────────────────────────────────
  void detectConflicts() {
    for (final s in schedules) { s.hasConflict = false; s.conflictType = ''; }
    for (int i = 0; i < schedules.length; i++) {
      for (int j = i + 1; j < schedules.length; j++) {
        final a = schedules[i]; final b = schedules[j];
        if (a.day != b.day || a.time != b.time) continue;
        if (a.room == b.room) {
          a.hasConflict = true; b.hasConflict = true;
          _setConflict(a, 'Room already occupied'); _setConflict(b, 'Room already occupied');
        }
        if (a.instructor == b.instructor) {
          a.hasConflict = true; b.hasConflict = true;
          _setConflict(a, 'Instructor schedule conflict'); _setConflict(b, 'Instructor schedule conflict');
        }
      }
    }
  }

  void _setConflict(Schedule s, String type) {
    if (s.conflictType.isEmpty) { s.conflictType = type; }
    else if (!s.conflictType.contains(type)) { s.conflictType = '${s.conflictType} & $type'; }
  }

  // ── AUTO-GENERATE ─────────────────────────────────────────────────────────
  void autoGenerateSchedules() {
    final newSubjects = ['Computer Architecture','Numerical Methods','Capstone Project 1','Technical Writing','Professional Ethics'];
    final instrList   = ['Dr. Santos','Prof. Cruz','Dr. Lopez','Prof. Garcia','Prof. Martinez','Dr. Reyes','Prof. Torres'];
    final roomList2   = ['Room 308','Room 309','Conference Hall'];
    final days        = ['Monday','Tuesday','Wednesday','Thursday','Friday'];
    final times       = ['7:00 AM - 9:00 AM','9:00 AM - 11:00 AM','1:00 PM - 3:00 PM','3:00 PM - 5:00 PM'];
    final used        = <String>{};
    for (final s in schedules) { used.add('${s.room}_${s.day}_${s.time}'); used.add('${s.instructor}_${s.day}_${s.time}'); }
    for (int i = 0; i < newSubjects.length; i++) {
      bool placed = false;
      for (final d in days) {
        if (placed) break;
        for (final t in times) {
          if (placed) break;
          final room  = roomList2[i % roomList2.length];
          final instr = instrList[(i + 4) % instrList.length];
          final rk = '${room}_${d}_$t'; final ik = '${instr}_${d}_$t';
          if (!used.contains(rk) && !used.contains(ik)) {
            used.add(rk); used.add(ik);
            schedules.add(Schedule(id:nextScheduleId++, subject:newSubjects[i], instructor:instr, room:room, day:d, time:t));
            placed = true;
          }
        }
      }
    }
    detectConflicts();
  }
}
