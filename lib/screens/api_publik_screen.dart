import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiPublikScreen extends StatefulWidget {
  @override
  _ApiPublikScreenState createState() => _ApiPublikScreenState();
}

class _ApiPublikScreenState extends State<ApiPublikScreen> {
  String currencyResult = 'Loading currency data...';
  List<Map<String, dynamic>> exchangeHistory = []; // Menyimpan data perubahan nilai tukar dalam bentuk tabel

  @override
  void initState() {
    super.initState();
    _fetchCurrency();
  }

  Future<void> _fetchCurrency() async {
    final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        currencyResult = '1 USD = ${data['rates']['IDR']} IDR';

        // Simulasi data perubahan nilai tukar (misalnya dalam 4 tahun terakhir)
        exchangeHistory = [
          {'Year': '2021', 'Value (IDR)': data['rates']['IDR'] * 0.98}, // 2021
          {'Year': '2022', 'Value (IDR)': data['rates']['IDR'] * 1.00}, // 2022
          {'Year': '2023', 'Value (IDR)': data['rates']['IDR'] * 1.02}, // 2023
          {'Year': '2024', 'Value (IDR)': data['rates']['IDR'] * 1.05}, // 2024
        ];
      });
    } else {
      setState(() {
        currencyResult = 'Failed to load currency data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informasi Mata Uang')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.monetization_on, color: Colors.green),
                title: Text('Currency Exchange'),
                subtitle: Text(currencyResult),
              ),
            ),
            SizedBox(height: 20),
            Text('Tabel Perubahan Nilai Tukar USD ke IDR (Tahun ke Tahun)'),
            SizedBox(height: 10),
            // Tabel Data
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Year')),
                  DataColumn(label: Text('Value (IDR)')),
                ],
                rows: exchangeHistory.map((data) {
                  return DataRow(
                    cells: [
                      DataCell(Text(data['Year'])),
                      DataCell(Text(data['Value (IDR)'].toString())),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
