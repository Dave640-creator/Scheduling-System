class AppUser {
  final String email, password, role, idNumber, name;
  AppUser({required this.email, required this.password, required this.role, required this.idNumber, required this.name});
}

class Schedule {
  int id;
  String subject, instructor, room, day, time, conflictType;
  bool hasConflict, isArchived;
  Schedule({required this.id, required this.subject, required this.instructor, required this.room,
    required this.day, required this.time, this.hasConflict = false, this.conflictType = '', this.isArchived = false});
}

class Room {
  int id, capacity;
  String name, status, assignedSchedule;
  bool isArchived;
  Room({required this.id, required this.name, required this.capacity, required this.status, this.assignedSchedule = '', this.isArchived = false});
}

class PendingAccount {
  int id;
  String name, email, role, status, dateSubmitted;
  PendingAccount({required this.id, required this.name, required this.email, required this.role, required this.status, required this.dateSubmitted});
}

class Instructor {
  int id, subjects;
  String name, email, phone, department, status;
  Instructor({required this.id, required this.name, required this.email, required this.phone, required this.department, required this.subjects, required this.status});
}

class Student {
  final String studentId, name, email, program, yearLevel, status;
  const Student({required this.studentId, required this.name, required this.email, required this.program, required this.yearLevel, required this.status});
}

class Announcement {
  int id;
  String title, content, audience, author, authorRole, datePosted;
  Announcement({required this.id, required this.title, required this.content, required this.audience, required this.author, required this.authorRole, required this.datePosted});
}

class Report {
  int id;
  String type, term, dateGenerated, generatedBy;
  Report({required this.id, required this.type, required this.term, required this.dateGenerated, required this.generatedBy});
}
