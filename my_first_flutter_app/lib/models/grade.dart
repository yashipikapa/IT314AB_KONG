class Grade {
  final int? id;
  final int enrollmentId;
  final double score;
  final String remarks;
  final String? dateRecorded; // 'YYYY-MM-DD'

  final int? studentId;
  final String? studentName;
  final String? subjectCode;
  final String? subjectName;

  const Grade({
    this.id,
    required this.enrollmentId,
    required this.score,
    required this.remarks,
    this.dateRecorded,
    this.studentId,
    this.studentName,
    this.subjectCode,
    this.subjectName,
  });

  factory Grade.fromRow(Map<String, dynamic> row) => Grade(
        id: row['grade_id'] as int?,
        enrollmentId: row['enrollment_id'] as int,
        score: ((row['score'] as num?) ?? 0).toDouble(),
        remarks: (row['remarks'] as String?) ?? '',
        dateRecorded: row['date_recorded'] as String?,
        studentId: row['student_id'] as int?,
        studentName: row['student_name'] as String?,
        subjectCode: row['subject_code'] as String?,
        subjectName: row['subject_name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'enrollment_id': enrollmentId,
        'score': score,
        'remarks': remarks,
      };
}
