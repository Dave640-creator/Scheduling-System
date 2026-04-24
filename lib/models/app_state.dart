// lib/models/app_state.dart
import 'app_models.dart';

class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  List<AppUser> users = [
    AppUser(email: 'admin@tcgc.edu', password: 'admin123', role: 'admin', idNumber: '000001', name: 'Administrator'),
    AppUser(email: 'instructor@tcgc.edu', password: 'inst123', role: 'instructor', idNumber: '000002', name: 'Dr. Maria Santos'),
    AppUser(email: 'student@tcgc.edu', password: 'stud123', role: 'student', idNumber: '000003', name: 'Juan Dela Cruz'),
  ];

  List<Schedule> schedules = [
    Schedule(id: 1, subject: 'Data Structures', instructor: 'Dr. Santos', room: 'Room 301', day: 'Monday', time: '8:00 AM - 10:00 AM'),
    Schedule(id: 2, subject: 'Web Development', instructor: 'Prof. Cruz', room: 'Room 302', day: 'Monday', time: '10:00 AM - 12:00 PM'),
    Schedule(id: 3, subject: 'Database Systems', instructor: 'Dr. Santos', room: 'Room 303', day: 'Monday', time: '8:00 AM - 10:00 AM', hasConflict: true, conflictType: 'Instructor schedule conflict'),
    Schedule(id: 4, subject: 'Mobile App Dev', instructor: 'Prof. Garcia', room: 'Room 301', day: 'Tuesday', time: '2:00 PM - 4:00 PM'),
    Schedule(id: 5, subject: 'System Analysis', instructor: 'Dr. Lopez', room: 'Room 301', day: 'Tuesday', time: '2:00 PM - 4:00 PM', hasConflict: true, conflictType: 'Room already occupied'),
    Schedule(id: 6, subject: 'Computer Networks', instructor: 'Prof. Martinez', room: 'Room 304', day: 'Wednesday', time: '1:00 PM - 3:00 PM'),
    Schedule(id: 7, subject: 'Software Engineering', instructor: 'Dr. Reyes', room: 'Room 305', day: 'Thursday', time: '9:00 AM - 11:00 AM'),
    Schedule(id: 8, subject: 'Algorithms', instructor: 'Prof. Torres', room: 'Room 302', day: 'Friday', time: '3:00 PM - 5:00 PM'),
  ];
  int nextScheduleId = 9;

  List<Room> rooms = [
    Room(id: 1, name: 'Room 301', capacity: 40, status: 'Occupied', assignedSchedule: 'Data Structures - Monday 8:00 AM'),
    Room(id: 2, name: 'Room 302', capacity: 35, status: 'Occupied', assignedSchedule: 'Web Development - Monday 10:00 AM'),
    Room(id: 3, name: 'Room 303', capacity: 30, status: 'Occupied', assignedSchedule: 'Database Systems - Monday 8:00 AM'),
    Room(id: 4, name: 'Room 304', capacity: 45, status: 'Occupied', assignedSchedule: 'Computer Networks - Wednesday 1:00 PM'),
    Room(id: 5, name: 'Room 305', capacity: 40, status: 'Occupied', assignedSchedule: 'Software Engineering - Thursday 9:00 AM'),
    Room(id: 6, name: 'Room 306', capacity: 30, status: 'Available'),
    Room(id: 7, name: 'Room 307', capacity: 35, status: 'Available'),
    Room(id: 8, name: 'Lab 201', capacity: 25, status: 'Available'),
    Room(id: 9, name: 'Lab 202', capacity: 25, status: 'Occupied', assignedSchedule: 'Programming Lab - Tuesday 2:00 PM'),
    Room(id: 10, name: 'Conference Hall', capacity: 100, status: 'Available'),
  ];
  int nextRoomId = 11;

  List<PendingAccount> accounts = [
    PendingAccount(id: 1, name: 'Maria Santos', email: 'maria.santos@tcgc.edu', role: 'Instructor', status: 'Pending', dateSubmitted: '2026-04-22'),
    PendingAccount(id: 2, name: 'John Cruz', email: 'john.cruz@tcgc.edu', role: 'Student', status: 'Pending', dateSubmitted: '2026-04-22'),
    PendingAccount(id: 3, name: 'Ana Lopez', email: 'ana.lopez@tcgc.edu', role: 'Student', status: 'Pending', dateSubmitted: '2026-04-21'),
    PendingAccount(id: 4, name: 'Robert Garcia', email: 'robert.garcia@tcgc.edu', role: 'Instructor', status: 'Pending', dateSubmitted: '2026-04-21'),
    PendingAccount(id: 5, name: 'Lisa Martinez', email: 'lisa.martinez@tcgc.edu', role: 'Student', status: 'Pending', dateSubmitted: '2026-04-20'),
    PendingAccount(id: 6, name: 'Carlos Reyes', email: 'carlos.reyes@tcgc.edu', role: 'Student', status: 'Approved', dateSubmitted: '2026-04-19'),
    PendingAccount(id: 7, name: 'Nina Torres', email: 'nina.torres@tcgc.edu', role: 'Instructor', status: 'Approved', dateSubmitted: '2026-04-18'),
  ];

  static const List<Instructor> instructors = [
    Instructor(name: 'Dr. Maria Santos', email: 'maria.santos@tcgc.edu', phone: '+63 917 123 4567', department: 'Computer Science', subjects: 3, status: 'Active'),
    Instructor(name: 'Prof. John Cruz', email: 'john.cruz@tcgc.edu', phone: '+63 917 234 5678', department: 'Computer Science', subjects: 2, status: 'Active'),
    Instructor(name: 'Dr. Ana Lopez', email: 'ana.lopez@tcgc.edu', phone: '+63 917 345 6789', department: 'Information Technology', subjects: 2, status: 'Active'),
    Instructor(name: 'Prof. Robert Garcia', email: 'robert.garcia@tcgc.edu', phone: '+63 917 456 7890', department: 'Computer Science', subjects: 1, status: 'Active'),
    Instructor(name: 'Dr. Lisa Martinez', email: 'lisa.martinez@tcgc.edu', phone: '+63 917 567 8901', department: 'Information Systems', subjects: 2, status: 'Active'),
    Instructor(name: 'Prof. Carlos Reyes', email: 'carlos.reyes@tcgc.edu', phone: '+63 917 678 9012', department: 'Computer Science', subjects: 1, status: 'Active'),
    Instructor(name: 'Dr. Nina Torres', email: 'nina.torres@tcgc.edu', phone: '+63 917 789 0123', department: 'Information Technology', subjects: 1, status: 'Inactive'),
  ];

  static const List<Student> students = [
    Student(studentId: '2024-001', name: 'Juan Dela Cruz', email: 'juan.delacruz@tcgc.edu', program: 'BS Computer Science', yearLevel: '3rd Year', status: 'Active'),
    Student(studentId: '2024-002', name: 'Maria Clara', email: 'maria.clara@tcgc.edu', program: 'BS Information Technology', yearLevel: '2nd Year', status: 'Active'),
    Student(studentId: '2024-003', name: 'Pedro Santos', email: 'pedro.santos@tcgc.edu', program: 'BS Computer Science', yearLevel: '4th Year', status: 'Active'),
    Student(studentId: '2024-004', name: 'Ana Reyes', email: 'ana.reyes@tcgc.edu', program: 'BS Information Systems', yearLevel: '1st Year', status: 'Active'),
    Student(studentId: '2024-005', name: 'Carlos Lopez', email: 'carlos.lopez@tcgc.edu', program: 'BS Computer Science', yearLevel: '2nd Year', status: 'Active'),
    Student(studentId: '2024-006', name: 'Lisa Garcia', email: 'lisa.garcia@tcgc.edu', program: 'BS Information Technology', yearLevel: '3rd Year', status: 'Active'),
    Student(studentId: '2024-007', name: 'Robert Martinez', email: 'robert.martinez@tcgc.edu', program: 'BS Computer Science', yearLevel: '1st Year', status: 'Active'),
    Student(studentId: '2024-008', name: 'Nina Torres', email: 'nina.torres@tcgc.edu', program: 'BS Information Systems', yearLevel: '2nd Year', status: 'Inactive'),
    Student(studentId: '2024-009', name: 'Jose Ramos', email: 'jose.ramos@tcgc.edu', program: 'BS Information Technology', yearLevel: '4th Year', status: 'Active'),
    Student(studentId: '2024-010', name: 'Carmen Cruz', email: 'carmen.cruz@tcgc.edu', program: 'BS Computer Science', yearLevel: '3rd Year', status: 'Active'),
  ];

  static const List<Map<String, dynamic>> studentSchedule = [
    {'subject': 'Data Structures', 'instructor': 'Dr. Santos', 'room': 'Room 301', 'day': 'Monday', 'time': '8:00 AM - 10:00 AM'},
    {'subject': 'Web Development', 'instructor': 'Prof. Cruz', 'room': 'Room 302', 'day': 'Monday', 'time': '10:00 AM - 12:00 PM'},
    {'subject': 'Mobile App Development', 'instructor': 'Prof. Garcia', 'room': 'Room 301', 'day': 'Tuesday', 'time': '2:00 PM - 4:00 PM'},
    {'subject': 'Computer Networks', 'instructor': 'Prof. Martinez', 'room': 'Room 304', 'day': 'Wednesday', 'time': '1:00 PM - 3:00 PM'},
    {'subject': 'Software Engineering', 'instructor': 'Dr. Reyes', 'room': 'Room 305', 'day': 'Thursday', 'time': '9:00 AM - 11:00 AM'},
    {'subject': 'Algorithms', 'instructor': 'Prof. Torres', 'room': 'Room 302', 'day': 'Friday', 'time': '3:00 PM - 5:00 PM'},
  ];

  AppUser? login(String emailOrId, String password) {
    for (var u in users) {
      if ((u.email == emailOrId || u.idNumber == emailOrId) && u.password == password) {
        return u;
      }
    }
    return null;
  }

  void detectConflicts() {
    for (var s in schedules) {
      s.hasConflict = false;
      s.conflictType = '';
    }
    for (int i = 0; i < schedules.length; i++) {
      for (int j = i + 1; j < schedules.length; j++) {
        final a = schedules[i];
        final b = schedules[j];
        if (a.day == b.day && a.time == b.time) {
          if (a.room == b.room) {
            a.hasConflict = true;
            b.hasConflict = true;
            a.conflictType = 'Room already occupied';
            b.conflictType = 'Room already occupied';
          }
          if (a.instructor == b.instructor) {
            a.hasConflict = true;
            b.hasConflict = true;
            final extra = 'Instructor schedule conflict';
            a.conflictType = a.conflictType.isEmpty ? extra : '${a.conflictType} & $extra';
            b.conflictType = b.conflictType.isEmpty ? extra : '${b.conflictType} & $extra';
          }
        }
      }
    }
  }

  void autoGenerateSchedules() {
    final subjects = ['Object Oriented Programming', 'Programming Fundamentals', 'Discrete Math', 'Operating Systems', 'Computer Architecture'];
    final instrList = ['Dr. Santos', 'Prof. Cruz', 'Dr. Lopez', 'Prof. Garcia', 'Prof. Martinez', 'Dr. Reyes', 'Prof. Torres'];
    final roomList = ['Room 306', 'Room 307', 'Lab 201'];
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final times = ['7:00 AM - 9:00 AM', '9:00 AM - 11:00 AM', '1:00 PM - 3:00 PM', '3:00 PM - 5:00 PM'];

    final usedSlots = <String>{};
    for (var s in schedules) {
      usedSlots.add('${s.room}_${s.day}_${s.time}');
      usedSlots.add('${s.instructor}_${s.day}_${s.time}');
    }

    int added = 0;
    for (int i = 0; i < subjects.length; i++) {
      bool placed = false;
      for (final day in days) {
        if (placed) break;
        for (final time in times) {
          if (placed) break;
          final room = roomList[i % roomList.length];
          final instr = instrList[(i + 3) % instrList.length];
          final rk = '${room}_${day}_$time';
          final ik = '${instr}_${day}_$time';
          if (!usedSlots.contains(rk) && !usedSlots.contains(ik)) {
            usedSlots.add(rk);
            usedSlots.add(ik);
            schedules.add(Schedule(
              id: nextScheduleId++,
              subject: subjects[i],
              instructor: instr,
              room: room,
              day: day,
              time: time,
            ));
            added++;
            placed = true;
          }
        }
      }
    }
    detectConflicts();
  }
}
