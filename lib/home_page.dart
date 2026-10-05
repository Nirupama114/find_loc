import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';
import 'food_page.dart';
import 'medical_page.dart';
import 'plumber_page.dart';
import 'electrician_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _userPosition;
  String _locationStatus = "Fetching your location...";

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  void _loadLocation() async {
    try {
      Position? pos = await LocationService.determinePosition();
      setState(() {
        _userPosition = pos;
        _locationStatus = "Location sync success!";
      });
    } catch (e) {
      setState(() {
        _locationStatus = e.toString();
      });
    }
  }

  void _navigateToPage(Widget targetPage) {
    if (_userPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Still fetching location or GPS is off. Please wait a moment!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetPage),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find_loc", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.orangeAccent),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.orangeAccent),
              ),
              accountName: Text("Nirupama Yeasmin Nisa", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              accountEmail: Text("nirupamanisa@gmail.com"),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.orangeAccent),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.orangeAccent),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Logout"),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _userPosition != null ? Icons.check_circle : Icons.location_searching,
                    color: _userPosition != null ? Colors.green : Colors.orange,
                    size: 70,
                  ),
                  const SizedBox(height: 15),
                  const Text("Welcome to Find_loc!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 5),
                  Text(_locationStatus, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Food Card with 'food_shop.jpeg'
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      child: Image.asset(
                        'assets/food_shop.jpeg',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: Colors.grey[300],
                          child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Delicious Food", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text("Find nearby restaurants", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _navigateToPage(FoodPage(userPosition: _userPosition)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                            child: const Text("Order Now", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Medical Card with 'medical_service.jpeg'
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      child: Image.asset(
                        'assets/medical_service.jpeg',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: Colors.grey[300],
                          child: const Icon(Icons.local_hospital, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Medical Services", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text("Find hospitals & pharmacies", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _navigateToPage(MedicalPage(userPosition: _userPosition)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                            child: const Text("Find Now", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Plumber Card with Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      child: Image.asset(
                        'assets/plumber.jpeg', // আপনার প্লাম্বার ছবির ফাইল নাম অনুযায়ী পরিবর্তন করতে পারেন
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: Colors.grey[300],
                          child: const Icon(Icons.plumbing, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Plumber Service", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text("Find nearby plumbers", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _navigateToPage(PlumberPage(userPosition: _userPosition)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                            child: const Text("Find Now", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Electrician Card with Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      child: Image.asset(
                        'assets/electrician.jpeg', // আপনার ইলেকট্রিশিয়ান ছবির ফাইল নাম অনুযায়ী পরিবর্তন করতে পারেন
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: Colors.grey[300],
                          child: const Icon(Icons.electrical_services, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Electrician Service", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text("Find nearby electricians", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _navigateToPage(ElectricianPage(userPosition: _userPosition)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                            child: const Text("Find Now", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
              child: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }
}