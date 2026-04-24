// lib/models/app_models.dart

class AppUser {
  final String email;
  final String password;
  final String role; // admin, instructor, student
  final String idNumber;
  final String name;

  AppUser({
    required this.email,
    required this.password,
    required this.role,
    required this.idNumber,
    required this.name,
  });
}

class Schedule {
  int id;
  String subject;
  String instructor;
  String room;
  String day;
  String time;
  bool hasConflict;
  String conflictType;

  Schedule({
    required this.id,
    required this.subject,
    required this.instructor,
    required this.room,
    required this.day,
    required this.time,
    this.hasConflict = false,
    this.conflictType = '',
  });
}

class Room {
  int id;
  String name;
  int capacity;
  String status; // Available, Occupied
  String assignedSchedule;

  Room({
    required this.id,
    required this.name,
    required this.capacity,
    required this.status,
    this.assignedSchedule = '',
  });
}

class PendingAccount {
  int id;
  String name;
  String email;
  String role;
  String status; // Pending, Approved, Rejected
  String dateSubmitted;

  PendingAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.dateSubmitted,
  });
}

class Instructor {
  final String name;
  final String email;
  final String phone;
  final String department;
  final int subjects;
  final String status;

  const Instructor({
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.subjects,
    required this.status,
  });
}

class Student {
  final String studentId;
  final String name;
  final String email;
  final String program;
  final String yearLevel;
  final String status;

  const Student({
    required this.studentId,
    required this.name,
    required this.email,
    required this.program,
    required this.yearLevel,
    required this.status,
  });
}
