import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../utils/api_constants.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isOtpSent = false;
  bool _isLoading = false;

  Future<void> _sendOtp() async {

    if (_emailController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {

      final response = await http.post(
        Uri.parse(SEND_OTP_ENDPOINT),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          'email': _emailController.text,
        }),
      );

      final data = jsonDecode(response.body);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {

        setState(() {
          _isOtpSent = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully'),
          ),
        );

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['error'] ?? 'Failed to send OTP'),
          ),
        );
      }

    } catch (e) {

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Future<void> _verifyOtp() async {

    if (_otpController.text.length != 6) return;

    setState(() {
      _isLoading = true;
    });

    try {

      final response = await http.post(
        Uri.parse(VERIFY_OTP_ENDPOINT),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          'email': _emailController.text,
          'otp': _otpController.text,
        }),
      );

      final data = jsonDecode(response.body);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {

        if (mounted) {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['error'] ?? 'Invalid OTP'),
          ),
        );
      }

    } catch (e) {

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      body: Center(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(
            AppDimensions.paddingLarge,
          ),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Container(

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.lock_person_rounded,
                  size: 80,
                  color: AppColors.accent,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                _isOtpSent ? 'Verify OTP' : 'Login',
                style: AppTextStyles.heading,
              ),

              const SizedBox(height: 8),

              Text(

                _isOtpSent
                    ? 'Enter the 6-digit OTP sent to your email'
                    : 'Enter your email to receive OTP',

                textAlign: TextAlign.center,

                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 48),

              if (!_isOtpSent)

                TextField(

                  controller: _emailController,

                  keyboardType: TextInputType.emailAddress,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(

                    hintText: 'Email Address',

                    hintStyle: const TextStyle(
                      color: AppColors.textSecondary,
                    ),

                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.accent,
                    ),

                    filled: true,

                    fillColor: AppColors.surface,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMedium,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

              if (_isOtpSent)

                TextField(

                  controller: _otpController,

                  keyboardType: TextInputType.number,

                  maxLength: 6,

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: 8,
                  ),

                  decoration: InputDecoration(

                    hintText: '000000',

                    counterText: "",

                    hintStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      letterSpacing: 8,
                    ),

                    filled: true,

                    fillColor: AppColors.surface,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMedium,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              SizedBox(

                width: double.infinity,
                height: 56,

                child: ElevatedButton(

                  onPressed: _isLoading
                      ? null
                      : (_isOtpSent ? _verifyOtp : _sendOtp),

                  style: ElevatedButton.styleFrom(

                    backgroundColor: AppColors.accent,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMedium,
                      ),
                    ),
                  ),

                  child: _isLoading

                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )

                      : Text(

                          _isOtpSent
                              ? 'Verify & Login'
                              : 'Send OTP',

                          style: AppTextStyles.button,
                        ),
                ),
              ),

              if (_isOtpSent)

                TextButton(

                  onPressed: () {

                    setState(() {
                      _isOtpSent = false;
                    });
                  },

                  child: const Text(
                    'Change Email',
                    style: TextStyle(
                      color: AppColors.accent,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}