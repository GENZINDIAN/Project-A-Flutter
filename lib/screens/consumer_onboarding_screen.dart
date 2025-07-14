import 'package:flutter/material.dart';
import 'package:consumer_app/services/api_service.dart';

class ConsumerOnboardingScreen extends StatefulWidget {
  final String phone;
  const ConsumerOnboardingScreen({super.key, required this.phone});

  @override
  State<ConsumerOnboardingScreen> createState() => _ConsumerOnboardingScreenState();
}

class _ConsumerOnboardingScreenState extends State<ConsumerOnboardingScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _flatNumberController = TextEditingController();
  final TextEditingController _profileImageUrlController = TextEditingController();
  String? _selectedGender;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _preferredLanguageController = TextEditingController();

  void _consumerOnboarding() async {
    try {
      final result = await _apiService.post(
        'onboarding/consumer',
        {
          'flat_number': _flatNumberController.text,
          'profile_image_url': _profileImageUrlController.text,
          'gender': _selectedGender,
          'date_of_birth': _dobController.text,
          'preferred_language': _preferredLanguageController.text,
        },
      );
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Consumer onboarding complete!")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ShopListScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: ${result['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumer Onboarding'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _flatNumberController,
              decoration: const InputDecoration(labelText: 'Flat Number'),
            ),
            TextField(
              controller: _profileImageUrlController,
              decoration: const InputDecoration(labelText: 'Profile Image URL'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              hint: const Text('Select Gender'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              items: <String>['Male', 'Female', 'Other']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _dobController,
              decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _preferredLanguageController,
              decoration: const InputDecoration(labelText: 'Preferred Language'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _consumerOnboarding,
              child: const Text('Complete Consumer Onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}



import 'package:consumer_app/screens/shop_list_screen.dart';

