class Schedule {
  final int? id;
  final int subjectId;
  final String dayOfWeek;
  final String startTime; // 'HH:mm:ss'
  final String endTime; // 'HH:mm:ss'
  final String room;
  final int slotCapacity;

  // Joined / computed values (display only)
  final String? subjectCode;
  final String? subjectName;
  final int? enrolledCount;

  const Schedule({
    this.id,
    required this.subjectId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.slotCapacity,
    this.subjectCode,
    this.subjectName,
    this.enrolledCount,
  });

  factory Schedule.fromRow(Map<String, dynamic> row) => Schedule(
        id: row['schedule_id'] as int?,
        subjectId: row['subject_id'] as int,
        dayOfWeek: row['day_of_week'] as String,
        startTime: row['start_time'] as String,
        endTime: row['end_time'] as String,
        room: (row['room'] as String?) ?? '',
        slotCapacity: (row['slot_capacity'] as int?) ?? 0,
        subjectCode: row['subject_code'] as String?,
        subjectName: row['subject_name'] as String?,
        enrolledCount: row['enrolled_count'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'subject_id': subjectId,
        'day_of_week': dayOfWeek,
        'start_time': startTime,
        'end_time': endTime,
        'room': room,
        'slot_capacity': slotCapacity,
      };

  static String _hm(String t) => t.length >= 5 ? t.substring(0, 5) : t;

  String get timeLabel => '${_hm(startTime)} - ${_hm(endTime)}';
  String get label => '$dayOfWeek $timeLabel • Room $room';
  int get slotsLeft => slotCapacity - (enrolledCount ?? 0);
}
