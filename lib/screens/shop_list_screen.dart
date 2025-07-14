import 'package:flutter/material.dart';
import 'package:consumer_app/services/api_service.dart';

class ShopListScreen extends StatefulWidget {
  const ShopListScreen({super.key});

  @override
  State<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _shops = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchShops();
  }

  Future<void> _fetchShops() async {
    try {
      final result = await _apiService.get('shops');
      if (result['status'] == 'success') {
        setState(() {
          _shops = result['shops'];
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
        _errorMessage = 'Error fetching shops: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shops Near You"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
            },
          ),
        ],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _shops.length,
                  itemBuilder: (context, index) {
                    final shop = _shops[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemListScreen(
                                shopId: shop["shop_id"],
                                shopName: shop["shop_name"],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shop["shop_name"],
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text("Type: ${shop["shop_type"]}"),
                              Text("Description: ${shop["description"] ?? "N/A"}"),
                              Text("Status: ${shop["is_open"] ? "Open" : "Closed"}"),
                              Text("Delivers: ${shop["delivers"] ? "Yes" : "No"}"),
                              Text("Appointment Only: ${shop["appointment_only"] ? "Yes" : "No"}"),
                              Text("Tags: ${shop["category_tags"] ?? "N/A"}"),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}



import 'package:consumer_app/screens/item_list_screen.dart';


import 'package:consumer_app/screens/cart_screen.dart';
import 'package:consumer_app/screens/order_screen.dart';


import 'package:consumer_app/screens/wallet_screen.dart';

