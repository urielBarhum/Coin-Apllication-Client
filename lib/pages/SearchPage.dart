import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/models/coin.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/services/api_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ApiService api = ApiService.getApi();
  TextEditingController _searchController = TextEditingController();
  String? _searchText;
  bool fetched = false;
  Coin? coin;
  bool error = false;

  Future<void> handleSearch() async {
    setState(() {
      error = false;
    });
    if (_searchText != null && _searchText!.isNotEmpty) {
      try {
        final fetchedCoin = await api.getOneCoin(_searchText.toString());
        setState(() {
          fetched = true;
          error = false;
          coin = fetchedCoin;
        });
      } catch (err) {
        setState(() {
          error = true;
          coin = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF28E865),
        title: Text(
          'Search Coin',
          style: TextStyle(
            // You can customize the text style as needed
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true, // Center the title text
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Search for a coin:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter coin symbol (e.g., BTC)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {
                    _searchText = text;
                  });
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    handleSearch();
                  },
                  child: Text('Search'),
                ),
              ),
              SizedBox(height: 30),
              if (coin != null) ...[
                Center(
                  child: Text(
                    'Coin Information:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.maxFinite,
                  color: Colors.green[100], // Background color for found coin
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${coin!.id}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Name: ${coin!.name}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Price: \$${coin!.price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Low: ${coin!.low.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'High: ${coin!.high.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Open Market: ${coin!.openMarket.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Close Market: ${coin!.closeMarket.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Trending: ${coin!.trending ? 'Yes' : 'No'}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ] else if (error == true) ...[
                Center(
                  child: Text(
                    'No Coin Found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 30),
              Center(
                child:
                    Lottie.asset("assets/coins.json", height: 200, width: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
