class AppConfig {
  // API Configuration
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'YOUR_API_BASE_URL',
  );

  // Twilio Configuration
  static const String twilioAccountSid = String.fromEnvironment(
    'TWILIO_ACCOUNT_SID',
    defaultValue: 'YOUR_TWILIO_ACCOUNT_SID',
  );
  static const String twilioAuthToken = String.fromEnvironment(
    'TWILIO_AUTH_TOKEN',
    defaultValue: 'YOUR_TWILIO_AUTH_TOKEN',
  );
  static const String twilioVerifyServiceSid = String.fromEnvironment(
    'TWILIO_VERIFY_SERVICE_SID',
    defaultValue: 'YOUR_TWILIO_VERIFY_SERVICE_SID',
  );

  // Timeouts
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // Other configurations
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );
}
