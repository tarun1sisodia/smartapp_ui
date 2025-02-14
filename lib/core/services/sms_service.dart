import 'package:dio/dio.dart';
import 'dart:convert';
import '../config/app_config.dart';

class SMSService {
  final Dio _dio;
  final String _twilioAccountSid;
  final String _twilioAuthToken;
  final String _verifyServiceSid;
  static const String _twilioVerifyBaseUrl =
      'https://verify.twilio.com/v2/Services';

  SMSService({
    required String twilioAccountSid,
    required String twilioAuthToken,
    required String twilioVerifyServiceSid,
  })  : _twilioAccountSid = twilioAccountSid,
        _twilioAuthToken = twilioAuthToken,
        _verifyServiceSid = twilioVerifyServiceSid,
        _dio = Dio(BaseOptions(
          baseUrl: _twilioVerifyBaseUrl,
          headers: {
            'Authorization': 'Basic ' +
                base64Encode(utf8.encode('$twilioAccountSid:$twilioAuthToken')),
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ));

  String _formatPhoneNumber(String phoneNumber) {
    // Remove any spaces or special characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // If it's an Indian number without country code
    if (!cleaned.startsWith('+')) {
      // Remove leading zeros if any
      cleaned = cleaned.replaceAll(RegExp(r'^0+'), '');

      // If it starts with '91', add the '+' prefix
      if (cleaned.startsWith('91')) {
        return '+$cleaned';
      }
      // Otherwise, add the '+91' prefix
      return '+91$cleaned';
    }

    return cleaned;
  }

  // Send OTP using Twilio Verify
  Future<void> sendOTP(String phoneNumber, String channel) async {
    try {
      final formattedPhone = _formatPhoneNumber(phoneNumber);

      print('Initiating verification for: $formattedPhone');
      print('Using Verify Service SID: $_verifyServiceSid');

      final response = await _dio.post(
        '/$_verifyServiceSid/Verifications',
        data: FormData.fromMap({
          'To': formattedPhone,
          'Channel': channel, // 'sms' or 'call'
          'Locale': 'en', // You can change this based on your needs
        }),
      );

      print('Verification Request Response: ${response.data}');

      if (response.statusCode != 201) {
        throw Exception('Failed to send verification: ${response.data}');
      }
    } catch (e) {
      print('Verification Error: $e');
      throw Exception('Failed to send verification: $e');
    }
  }

  // Verify OTP
  Future<bool> verifyOTP(String phoneNumber, String code) async {
    try {
      final formattedPhone = _formatPhoneNumber(phoneNumber);

      print('Verifying code for: $formattedPhone');

      final response = await _dio.post(
        '/$_verifyServiceSid/VerificationCheck',
        data: FormData.fromMap({
          'To': formattedPhone,
          'Code': code,
        }),
      );

      print('Verification Check Response: ${response.data}');

      if (response.statusCode == 200) {
        final status = response.data['status'] as String?;
        return status?.toLowerCase() == 'approved';
      }

      return false;
    } catch (e) {
      print('Verification Check Error: $e');
      throw Exception('Failed to verify code: $e');
    }
  }

  // Test method to verify SMS functionality
  Future<bool> testSMSService() async {
    try {
      // Test with an Indian phone number
      await sendOTP('6398454306', 'sms');
      return true;
    } catch (e) {
      print('Test SMS failed: $e');
      return false;
    }
  }
}
