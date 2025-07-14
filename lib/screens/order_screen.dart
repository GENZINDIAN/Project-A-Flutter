import 'package:flutter/material.dart';
import 'package:consumer_app/services/api_service.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final result = await _apiService.get('orders');
      if (result['status'] == 'success') {
        setState(() {
          _orders = result['orders'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching orders: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _placeOrder() async {
    try {
      final result = await _apiService.post('order/place', {});
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed successfully!')));
        _fetchOrders(); // Refresh orders after placing a new one
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order: ${result['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error placing order: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: _placeOrder,
            tooltip: 'Place Order',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _orders.isEmpty
                  ? const Center(child: Text('No orders found.'))
                  : ListView.builder(
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        final order = _orders[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order ID: ${order["order_id"]}",
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text("Status: ${order["status"]}"),
                                Text("Total: ₹${order["total_amount"]}"),
                                Text("Order Date: ${order["order_date"]}"),
                                // Display order items
                                ...order["items"].map<Widget>((item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                                    child: Text("${item["title"]} x ${item["quantity"]} - ₹${item["price"]}"),
                                  );
                                }).toList(),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderFeedbackScreen(orderId: order["order_id"]),
                                      ),
                                    );
                                  },
                                  child: const Text("Provide Feedback"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}



import 'package:consumer_app/screens/order_feedback_screen.dart';

