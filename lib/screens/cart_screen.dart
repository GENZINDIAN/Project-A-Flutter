import 'package:flutter/material.dart';
import 'package:consumer_app/services/api_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _cartItems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    try {
      final result = await _apiService.get('cart');
      if (result['status'] == 'success') {
        setState(() {
          _cartItems = result['cart_items'];
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
        _errorMessage = 'Error fetching cart items: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateCartItemQuantity(int itemId, int quantity) async {
    try {
      final result = await _apiService.post('cart/update', {
        'item_id': itemId,
        'quantity': quantity,
      });
      if (result['status'] == 'success') {
        _fetchCartItems(); // Refresh cart after update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update quantity: ${result['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating quantity: $e')));
    }
  }

  Future<void> _removeCartItem(int itemId) async {
    try {
      final result = await _apiService.post('cart/remove', {
        'item_id': itemId,
      });
      if (result['status'] == 'success') {
        _fetchCartItems(); // Refresh cart after removal
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to remove item: ${result['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error removing item: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _cartItems.isEmpty
                  ? const Center(child: Text('Your cart is empty.'))
                  : ListView.builder(
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text('Price: ₹${item['price']}'),
                                Text('Quantity: ${item['quantity']}'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle),
                                      onPressed: () {
                                        if (item['quantity'] > 1) {
                                          _updateCartItemQuantity(item['item_id'], item['quantity'] - 1);
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle),
                                      onPressed: () {
                                        _updateCartItemQuantity(item['item_id'], item['quantity'] + 1);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _removeCartItem(item['item_id']);
                                      },
                                    ),
                                  ],
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


