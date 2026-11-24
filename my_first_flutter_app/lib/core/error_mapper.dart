import 'dart:async';
import 'dart:io';
import 'package:postgres/postgres.dart';

class ErrorMapper {
  static String map(Object error) {
    if (error is ServerException) {
      final constraint = (error.constraintName ?? '').toLowerCase();
      switch (error.code) {
        case '23505': // unique_violation
          if (constraint.contains('email'))
            return 'That email is already used by another student.';
          if (constraint.contains('student_number'))
            return 'That student number already exists.';
          if (constraint.contains('subject_code'))
            return 'That subject code already exists.';
          if (constraint.contains('enrollment_id'))
            return 'This enrollment already has a grade. Edit it instead.';
          if (constraint.contains('student_id') ||
              constraint.contains('subject_id')) {
            return 'The student is already enrolled in this subject.';
          }
          return 'A record with the same unique value already exists.';
        case '23503': // foreign_key_violation
          return 'This record is linked to other records (for example enrollments or grades). Remove those first.';
        case '23502': // not_null_violation
          return 'A required field is missing.';
        case '22001': // string_data_right_truncation
          return 'One of the values is too long.';
        case '22003': // numeric_value_out_of_range
          return 'A number is out of the allowed range.';
        case '22P02':
        case '22007':
        case '22008':
          return 'One of the values has an invalid format.';
        case '23514': // check_violation
          return 'A value does not satisfy the database rules.';
      }
      return 'Database error: ${error.message}';
    }
    if (error is TimeoutException) {
      return 'The database took too long to respond. Please try again.';
    }
    if (error is SocketException || error is HandshakeException) {
      return 'Cannot reach the database. Check your internet connection.';
    }
    if (error is PgException) {
      return 'Database error: ${error.message}';
    }
    return error.toString();
  }
}
