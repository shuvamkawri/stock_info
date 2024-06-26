import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _stockData;
  bool _isLoading = false;

  void _fetchStockData(String symbol) async {
    setState(() {
      _isLoading = true;
    });

    final apiKey = '3F3QCH3ZBO0IAJK0';
    final url =
        'https://www.alphavantage.co/query?function=OVERVIEW&symbol=$symbol&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _stockData = json.decode(response.body);
        });
      } else {
        setState(() {
          _stockData = null;
        });
      }
    } catch (e) {
      setState(() {
        _stockData = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stock Info',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Search Field
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Stock Symbol',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _fetchStockData(_controller.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            // Search Button (Alternative)
            // ElevatedButton(
            //   onPressed: () {
            //     _fetchStockData(_controller.text);
            //   },
            //   child: Text('Search'),
            // ),

            // Loading Indicator
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _stockData != null
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Stock Info Display
                              Card(
                                elevation: 3,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _stockData!['Name'],
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Symbol: ${_stockData!['Symbol']}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Description: ${_stockData!['Description']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Sector: ${_stockData!['Sector']}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Market Cap: ${_stockData!['MarketCapitalization']}',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Data Table
                              Card(
                                elevation: 3,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: DataTable(
                                  columns: [
                                    DataColumn(label: Text('Metric')),
                                    DataColumn(label: Text('Value')),
                                  ],
                                  rows: [
                                    buildDataRow(
                                      'PE Ratio',
                                      _stockData!['PERatio'],
                                    ),
                                    buildDataRow(
                                      'PEG Ratio',
                                      _stockData!['PEGRatio'],
                                    ),
                                    buildDataRow(
                                      'Book Value',
                                      _stockData!['BookValue'],
                                    ),
                                    buildDataRow(
                                      'Dividend Per Share',
                                      _stockData!['DividendPerShare'],
                                    ),
                                    buildDataRow(
                                      'Dividend Yield',
                                      _stockData!['DividendYield'],
                                    ),
                                    buildDataRow(
                                      'EPS',
                                      _stockData!['EPS'],
                                    ),
                                    buildDataRow(
                                      'Revenue Per Share TTM',
                                      _stockData!['RevenuePerShareTTM'],
                                    ),
                                    buildDataRow(
                                      'Profit Margin',
                                      _stockData!['ProfitMargin'],
                                    ),
                                    buildDataRow(
                                      'Operating Margin TTM',
                                      _stockData!['OperatingMarginTTM'],
                                    ),
                                    buildDataRow(
                                      'Return On Assets TTM',
                                      _stockData!['ReturnOnAssetsTTM'],
                                    ),
                                    buildDataRow(
                                      'Return On Equity TTM',
                                      _stockData!['ReturnOnEquityTTM'],
                                    ),
                                    buildDataRow(
                                      'Revenue TTM',
                                      _stockData!['RevenueTTM'],
                                    ),
                                    buildDataRow(
                                      'Gross Profit TTM',
                                      _stockData!['GrossProfitTTM'],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'No data available. Please check the symbol and try again.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  DataRow buildDataRow(String label, dynamic value) {
    return DataRow(cells: [
      DataCell(Text(label)),
      DataCell(Text(value ?? 'N/A')),
    ]);
  }
}
