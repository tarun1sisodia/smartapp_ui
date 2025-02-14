class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error occurred']);
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException([this.message = 'Invalid request']);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Unauthorized access']);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Resource not found']);
}

class ValidationException implements Exception {
  final String message;
  ValidationException([this.message = 'Validation failed']);
}

class OTPException implements Exception {
  final String message;
  OTPException([this.message = 'OTP verification failed']);
}

class DeviceBindingException implements Exception {
  final String message;
  DeviceBindingException([this.message = 'Device binding failed']);
}
