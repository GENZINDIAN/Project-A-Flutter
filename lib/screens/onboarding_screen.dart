import 'package:flutter/material.dart';
import 'package:consumer_app/services/api_service.dart';

class OnboardingScreen extends StatefulWidget {
  final String phone;
  const OnboardingScreen({super.key, required this.phone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _societyController = TextEditingController();
  String? _selectedRole;

  void _basicOnboarding() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a role')));
      return;
    }
    try {
      final result = await _apiService.post(
        'onboarding/basic',
        {
          'name': _nameController.text,
          'city': _cityController.text,
          'society': _societyController.text,
          'role': _selectedRole,
        },
      );
      if (result["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Basic onboarding complete!")));
        if (_selectedRole == "consumer") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ConsumerOnboardingScreen(phone: widget.phone)),
          );
        } else if (_selectedRole == "vendor") {
          // TODO: Navigate to vendor specific onboarding
        } else {
          // TODO: Navigate to home screen or other appropriate screen
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed: ${result["message"]}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Onboarding'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _societyController,
              decoration: const InputDecoration(labelText: 'Society'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              hint: const Text('Select Role'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue;
                });
              },
              items: <String>['consumer', 'vendor']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _basicOnboarding,
              child: const Text('Complete Basic Onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}



import 'package:consumer_app/screens/consumer_onboarding_screen.dart';








import 'package:vendor_app/screens/vendor_onboarding_screen.dart';

