import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/failure.dart';
import '../../core/services/device_service.dart';
import '../../core/services/sms_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final DeviceService deviceService;
  final SMSService smsService;

  AuthRepositoryImpl({
    required this.dio,
    required this.deviceService,
    required this.smsService,
  });

  @override
  Future<Either<Failure, User>> registerTeacher({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String highestDegree,
    required String experience,
    required String password,
  }) async {
    try {
      // Get device info
      final deviceInfo = await deviceService.getDeviceInfo();
      final isDeveloperMode = await deviceService.isDeveloperModeEnabled();

      if (isDeveloperMode) {
        return const Left(ValidationFailure('Developer mode must be disabled'));
      }

      final requestData = {
        'full_name': fullName,
        'username': username,
        'email': email,
        'phone': phone,
        'highest_degree': highestDegree,
        'experience': experience,
        'password': password,
        'device_info': deviceInfo,
      };

      final response =
          await dio.post('/auth/register/teacher', data: requestData);

      if (response.statusCode == 201 && response.data['otp'] != null) {
        // Send OTP via SMS
        await smsService.sendOTP(phone, response.data['otp']);
      }

      return Right(User(
        id: response.data['user_id'],
        role: UserRole.teacher,
        fullName: fullName,
        username: username,
        email: email,
        phone: phone,
        highestDegree: highestDegree,
        experience: experience,
      ));
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> registerStudent({
    required String fullName,
    required String rollNumber,
    required String course,
    required String academicYear,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await dio.post('/auth/register/student', data: {
        'full_name': fullName,
        'roll_number': rollNumber,
        'course': course,
        'academic_year': academicYear,
        'phone': phone,
        'password': password,
      });

      return Right(User.fromJson(response.data['user']));
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOTP({
    required String userId,
    required String otp,
  }) async {
    try {
      await dio.post('/auth/verify-otp', data: {
        'user_id': userId,
        'otp': otp,
      });

      return const Right(true);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> loginTeacher({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post('/auth/login/teacher', data: {
        'email': email,
        'password': password,
      });

      return Right(User.fromJson(response.data['user']));
    } on DioException catch (e) {
      return Left(AuthenticationFailure(
          e.response?.data['message'] ?? 'Authentication failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> loginStudent({
    required String rollNumber,
    required String password,
  }) async {
    try {
      final response = await dio.post('/auth/login/student', data: {
        'roll_number': rollNumber,
        'password': password,
      });

      return Right(User.fromJson(response.data['user']));
    } on DioException catch (e) {
      return Left(AuthenticationFailure(
          e.response?.data['message'] ?? 'Authentication failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  }) async {
    try {
      await dio.post('/auth/reset-password', data: {
        'email': email,
        'new_password': newPassword,
        'otp': otp,
      });

      return const Right(true);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dio.post('/auth/logout');
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resendOTP({
    required String userId,
  }) async {
    try {
      final response = await dio.post('/auth/resend-otp', data: {
        'user_id': userId,
      });

      if (response.statusCode == 201 && response.data['otp'] != null) {
        // Get user's phone number from response
        final phone = response.data['phone'] as String?;
        if (phone != null) {
          // Send OTP via SMS
          await smsService.sendOTP(phone, response.data['otp']);
        }
      }

      return const Right(true);
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
