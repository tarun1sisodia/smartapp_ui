import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> registerTeacher({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String highestDegree,
    required String experience,
    required String password,
  });

  Future<Either<Failure, User>> registerStudent({
    required String fullName,
    required String rollNumber,
    required String course,
    required String academicYear,
    required String phone,
    required String password,
  });

  Future<Either<Failure, bool>> verifyOTP({
    required String userId,
    required String otp,
  });

  Future<Either<Failure, User>> loginTeacher({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginStudent({
    required String rollNumber,
    required String password,
  });

  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  });

  Future<Either<Failure, bool>> resendOTP({
    required String userId,
  });

  Future<Either<Failure, void>> logout();
}
