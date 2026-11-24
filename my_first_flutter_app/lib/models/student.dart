class Student {
  final int? id;
  final String studentNumber;
  final String studentName;
  final String email;
  final int? programId;
  final int yearLevel;
  final String contactNumber;
  final DateTime? createdAt;
  final String? programName; // joined from Program (display only)

  const Student({
    this.id,
    required this.studentNumber,
    required this.studentName,
    required this.email,
    required this.programId,
    required this.yearLevel,
    required this.contactNumber,
    this.createdAt,
    this.programName,
  });

  /// Database row -> object
  factory Student.fromRow(Map<String, dynamic> row) => Student(
        id: row['student_id'] as int?,
        studentNumber: row['student_number'] as String,
        studentName: row['student_name'] as String,
        email: (row['email'] as String?) ?? '',
        programId: row['program_id'] as int?,
        yearLevel: (row['year_level'] as int?) ?? 1,
        contactNumber: (row['contact_number'] as String?) ?? '',
        createdAt: row['created_at'] as DateTime?,
        programName: row['program_name'] as String?,
      );

  /// Object -> named SQL parameters (columns that can be written)
  Map<String, dynamic> toMap() => {
        'student_number': studentNumber,
        'student_name': studentName,
        'email': email,
        'program_id': programId,
        'year_level': yearLevel,
        'contact_number': contactNumber,
      };
}
