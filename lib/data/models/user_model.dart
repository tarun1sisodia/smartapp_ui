import 'package:equatable/equatable.dart';

enum UserRole { teacher, student }

class User extends Equatable {
  final String id;
  final UserRole role;
  final String fullName;
  final String? username; // For teachers
  final String? rollNumber; // For students
  final String? email; // Used for teacher login
  final String? course; // For student registration
  final String?
      academicYear; // For student registration and matching with session
  final String phone;
  final String? highestDegree; // For teachers
  final String? experience; // For teachers

  const User({
    required this.id,
    required this.role,
    required this.fullName,
    this.username,
    this.rollNumber,
    this.email,
    this.course,
    this.academicYear,
    required this.phone,
    this.highestDegree,
    this.experience,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
      ),
      fullName: json['full_name'] as String,
      username: json['username'] as String?,
      rollNumber: json['roll_number'] as String?,
      email: json['email'] as String?,
      course: json['course'] as String?,
      academicYear: json['academic_year'] as String?,
      phone: json['phone'] as String,
      highestDegree: json['highest_degree'] as String?,
      experience: json['experience'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.toString().split('.').last,
      'full_name': fullName,
      if (username != null) 'username': username,
      if (rollNumber != null) 'roll_number': rollNumber,
      if (email != null) 'email': email,
      if (course != null) 'course': course,
      if (academicYear != null) 'academic_year': academicYear,
      'phone': phone,
      if (highestDegree != null) 'highest_degree': highestDegree,
      if (experience != null) 'experience': experience,
    };
  }

  @override
  List<Object?> get props => [
        id,
        role,
        fullName,
        username,
        rollNumber,
        email,
        course,
        academicYear,
        phone,
        highestDegree,
        experience,
      ];
}
