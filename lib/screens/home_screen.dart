import 'package:elcomercio/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import 'api_publik_screen.dart';  // Import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List products = [];

  final String youtubeUrl = 'https://youtube.com/shorts/W76Ang5D2ys?si=Vet51LkLOR4pnpfn';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final data = await ApiService().fetchProducts();
      setState(() {
        products = data;
      });
    } catch (e) {
      print('Failed to load products: $e');
    }
  }

  void _launchWhatsApp(String productName, String price) async {
    const phoneNumber = '6281298905298'; // Ganti dengan nomor penjual
    final message = 'Halo, saya ingin membeli $productName dengan harga Rp $price.';
    final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Elcomercio Home')),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => ListView(
                children: [
                  ListTile(
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(), // Ganti '1' dengan ID pengguna dinamis
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  ListTile(
                    title: Text('Nilai Rupiah'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ApiPublikScreen()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Tentang Kami'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Tentang Kami'),
                          content: Text('Elcomercio adalah aplikasi belanja online yang di rancang dengan sangat sederhana. ~Developer-Hafizi'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.video_library),
            onPressed: () async {
              if (await canLaunch(youtubeUrl)) {
                await launch(youtubeUrl);
              } else {
                throw 'Could not launch $youtubeUrl';
              }
            },
          ),
        ],
      ),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final productName = product['name'];
          final price = product['price'].toString();
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(productName),
              subtitle: Text('Harga: Rp $price'),
              trailing: ElevatedButton(
                onPressed: () => _launchWhatsApp(productName, price),
                child: Text('Beli'),
              ),
            ),
          );
        },
      ),
    );
  }
}
