import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterTeacherEvent>(_onRegisterTeacher);
    on<RegisterStudentEvent>(_onRegisterStudent);
    on<VerifyOTPEvent>(_onVerifyOTP);
    on<LoginTeacherEvent>(_onLoginTeacher);
    on<LoginStudentEvent>(_onLoginStudent);
    on<LogoutEvent>(_onLogout);
    on<ResendOTPEvent>(_onResendOTP);
  }

  Future<void> _onRegisterTeacher(
    RegisterTeacherEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.registerTeacher(
      fullName: event.fullName,
      username: event.username,
      email: event.email,
      phone: event.phone,
      highestDegree: event.highestDegree,
      experience: event.experience,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (user) => emit(OTPSentState(user.id)),
    );
  }

  Future<void> _onRegisterStudent(
    RegisterStudentEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.registerStudent(
      fullName: event.fullName,
      rollNumber: event.rollNumber,
      course: event.course,
      academicYear: event.academicYear,
      phone: event.phone,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (user) => emit(OTPSentState(user.id)),
    );
  }

  Future<void> _onVerifyOTP(
    VerifyOTPEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.verifyOTP(
      userId: event.userId,
      otp: event.otp,
    );

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (success) => emit(OTPVerifiedState()),
    );
  }

  Future<void> _onLoginTeacher(
    LoginTeacherEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.loginTeacher(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (user) => emit(AuthenticatedState(user)),
    );
  }

  Future<void> _onLoginStudent(
    LoginStudentEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.loginStudent(
      rollNumber: event.rollNumber,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (user) => emit(AuthenticatedState(user)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (_) => emit(UnauthenticatedState()),
    );
  }

  Future<void> _onResendOTP(
    ResendOTPEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.resendOTP(
      userId: event.userId,
    );

    result.fold(
      (failure) => emit(AuthErrorState(failure.message)),
      (_) => emit(OTPResentState()),
    );
  }
}
