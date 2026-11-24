class Program {
  final int id;
  final String code;
  final String name;

  const Program({
    required this.id,
    required this.code,
    required this.name,
  });

  /// Database row -> object
  factory Program.fromRow(Map<String, dynamic> row) => Program(
        id: row['program_id'] as int,
        code: (row['program_code'] as String?) ?? '',
        name: (row['program_name'] as String?) ?? '',
      );

  /// Object -> named SQL parameters
  Map<String, dynamic> toMap() => {
        'program_code': code,
        'program_name': name,
      };
}
