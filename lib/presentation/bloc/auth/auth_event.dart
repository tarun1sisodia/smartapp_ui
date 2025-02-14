import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterTeacherEvent extends AuthEvent {
  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String highestDegree;
  final String experience;
  final String password;

  const RegisterTeacherEvent({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.highestDegree,
    required this.experience,
    required this.password,
  });

  @override
  List<Object> get props => [
        fullName,
        username,
        email,
        phone,
        highestDegree,
        experience,
        password,
      ];
}

class RegisterStudentEvent extends AuthEvent {
  final String fullName;
  final String rollNumber;
  final String course;
  final String academicYear;
  final String phone;
  final String password;

  const RegisterStudentEvent({
    required this.fullName,
    required this.rollNumber,
    required this.course,
    required this.academicYear,
    required this.phone,
    required this.password,
  });

  @override
  List<Object> get props => [
        fullName,
        rollNumber,
        course,
        academicYear,
        phone,
        password,
      ];
}

class VerifyOTPEvent extends AuthEvent {
  final String userId;
  final String otp;

  const VerifyOTPEvent({
    required this.userId,
    required this.otp,
  });

  @override
  List<Object> get props => [userId, otp];
}

class LoginTeacherEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginTeacherEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class LoginStudentEvent extends AuthEvent {
  final String rollNumber;
  final String password;

  const LoginStudentEvent({
    required this.rollNumber,
    required this.password,
  });

  @override
  List<Object> get props => [rollNumber, password];
}

class LogoutEvent extends AuthEvent {}

class ResendOTPEvent extends AuthEvent {
  final String userId;

  const ResendOTPEvent({
    required this.userId,
  });

  @override
  List<Object> get props => [userId];
}
