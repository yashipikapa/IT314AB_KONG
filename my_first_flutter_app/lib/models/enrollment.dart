class Enrollment {
  final int? id;
  final int studentId;
  final int subjectId;
  final int? scheduleId;
  final DateTime? enrolledAt;
  final String status;

  final String? studentName;
  final String? subjectCode;
  final String? subjectName;
  final String? dayOfWeek;
  final String? startTime;
  final String? endTime;
  final String? room;

  const Enrollment({
    this.id,
    required this.studentId,
    required this.subjectId,
    required this.scheduleId,
    this.enrolledAt,
    this.status = 'Enrolled',
    this.studentName,
    this.subjectCode,
    this.subjectName,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.room,
  });

  factory Enrollment.fromRow(Map<String, dynamic> row) => Enrollment(
        id: row['enrollment_id'] as int?,
        studentId: row['student_id'] as int,
        subjectId: row['subject_id'] as int,
        scheduleId: row['schedule_id'] as int?,
        enrolledAt: row['enrolled_at'] as DateTime?,
        status: (row['status'] as String?) ?? 'Enrolled',
        studentName: row['student_name'] as String?,
        subjectCode: row['subject_code'] as String?,
        subjectName: row['subject_name'] as String?,
        dayOfWeek: row['day_of_week'] as String?,
        startTime: row['start_time'] as String?,
        endTime: row['end_time'] as String?,
        room: row['room'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'student_id': studentId,
        'subject_id': subjectId,
        'schedule_id': scheduleId,
        'status': status,
      };

  static String _hm(String t) => t.length >= 5 ? t.substring(0, 5) : t;

  String get scheduleLabel {
    if (dayOfWeek == null || startTime == null || endTime == null) {
      return 'No schedule';
    }
    return '$dayOfWeek ${_hm(startTime!)} - ${_hm(endTime!)} • Room ${room ?? '-'}';
  }
}
