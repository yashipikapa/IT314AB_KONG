class Subject {
  final int? id;
  final String subjectCode;
  final String subjectName;
  final int units;
  final String description;
  final int? scheduleCount; // joined count (display only)

  const Subject({
    this.id,
    required this.subjectCode,
    required this.subjectName,
    required this.units,
    required this.description,
    this.scheduleCount,
  });

  factory Subject.fromRow(Map<String, dynamic> row) => Subject(
        id: row['subject_id'] as int?,
        subjectCode: row['subject_code'] as String,
        subjectName: row['subject_name'] as String,
        units: (row['units'] as int?) ?? 0,
        description: (row['description'] as String?) ?? '',
        scheduleCount: row['schedule_count'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'subject_code': subjectCode,
        'subject_name': subjectName,
        'units': units,
        'description': description,
      };
}
