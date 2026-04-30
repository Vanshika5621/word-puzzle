import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class AuthService {
  // Common headers for Localtunnel bypass
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'bypass-tunnel-reminder': 'true', // Important: Localtunnel splash screen bypass
  };

  // Method: Send OTP to Email
  static Future<Map<String, dynamic>> sendOTP(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${BackendConfig.baseUrl}/auth/send-otp'),
        headers: _headers,
        body: jsonEncode({'email': email}),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        return {'success': false, 'error': decoded['error'] ?? 'Server Error'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Connection Failed: Make sure server is running.'};
    }
  }

  // Method: Verify OTP
  static Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('${BackendConfig.baseUrl}/auth/verify-otp'),
        headers: _headers,
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        return {'success': false, 'error': decoded['error'] ?? 'Verification Failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Connection Failed'};
    }
  }
}
