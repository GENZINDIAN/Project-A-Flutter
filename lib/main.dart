


import 'package:consumer_app/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:consumer_app/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;

  void _sendOtp() async {
    try {
      final result = await _apiService.post('send-otp', {'phone': _phoneController.text});
      if (result['status'] == 'success') {
        setState(() {
          _otpSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send OTP: ${result['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _verifyOtp() async {
    try {
      final result = await _apiService.post('verify-otp', {'phone': _phoneController.text, 'otp': _otpController.text});
      if (result['status'] == 'success') {
        // Navigate to OnboardingScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen(phone: _phoneController.text)),
        );
        // In a real app, you would save the auth token securely (e.g., using shared_preferences or flutter_secure_storage)
        print("Auth Token: ${result["auth_token"]}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login successful!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to verify OTP: ${result['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            if (_otpSent)
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: 'OTP'),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _otpSent ? _verifyOtp : _sendOtp,
              child: Text(_otpSent ? 'Verify OTP' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}


