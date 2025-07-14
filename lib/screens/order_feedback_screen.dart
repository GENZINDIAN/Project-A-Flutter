import 'package:flutter/material.dart';
import 'package:consumer_app/services/api_service.dart';

class OrderFeedbackScreen extends StatefulWidget {
  final int orderId;

  const OrderFeedbackScreen({super.key, required this.orderId});

  @override
  State<OrderFeedbackScreen> createState() => _OrderFeedbackScreenState();
}

class _OrderFeedbackScreenState extends State<OrderFeedbackScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _returnReasonController = TextEditingController();

  Future<void> _submitFeedback() async {
    try {
      final result = await _apiService.post(
        'order/feedback',
        {
          'order_id': widget.orderId,
          'rating': int.parse(_ratingController.text),
          'issue': _issueController.text,
          'return_reason': _returnReasonController.text,
        },
      );
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback submitted successfully!')));
        Navigator.pop(context); // Go back to previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit feedback: ${result['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting feedback: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback for Order #${widget.orderId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _ratingController,
              decoration: const InputDecoration(labelText: 'Rating (1-5)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _issueController,
              decoration: const InputDecoration(labelText: 'Issue (Optional)'),
              maxLines: 3,
            ),
            TextField(
              controller: _returnReasonController,
              decoration: const InputDecoration(labelText: 'Return Reason (Optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}


