import 'package:flutter/material.dart';
import 'package:consumer_app/services/api_service.dart';

class ItemListScreen extends StatefulWidget {
  final int shopId;
  final String shopName;

  const ItemListScreen({super.key, required this.shopId, required this.shopName});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _items = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final result = await _apiService.get('items/shop/${widget.shopId}');
      if (result['status'] == 'success') {
        setState(() {
          _items = result['items'];
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
        _errorMessage = 'Error fetching items: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.shopName} - Items'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text("Brand: ${item["brand"] ?? "N/A"}"),
                            Text("Price: ₹${item["price"]}"),
                            Text("MRP: ₹${item["mrp"] ?? "N/A"}"),
                            Text("Discount: ${item["discount"] ?? "N/A"}%"),
                            Text("Description: ${item["description"] ?? "N/A"}"),
                            Text("Unit: ${item["unit"] ?? "N/A"}"),
                            Text("Pack Size: ${item["pack_size"] ?? "N/A"}"),
                            Text("Category: ${item["category"] ?? "N/A"}"),
                            Text("Tags: ${item["tags"] ?? "N/A"}"),
                            Text("Available: ${item["is_available"] ? "Yes" : "No"}"),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                _addToCart(item["item_id"], 1); // Add 1 quantity by default
                              },
                              child: const Text("Add to Cart"),
                            ),
                  },
                ),
    );
  }
}




  Future<void> _addToCart(int itemId, int quantity) async {
    try {
      final result = await _apiService.post(
        'cart/add',
        {
          'item_id': itemId,
          'quantity': quantity,
        },
      );
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item added to cart!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add item to cart: ${result['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding item to cart: $e')));
    }
  }


