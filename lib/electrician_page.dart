import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ElectricianPage extends StatefulWidget {
  final Position? userPosition;
  const ElectricianPage({super.key, this.userPosition});

  @override
  State<ElectricianPage> createState() => _ElectricianPageState();
}

class _ElectricianPageState extends State<ElectricianPage> {
  // ডামি ইলেকট্রিশিয়ান লিস্ট
  final List<Map<String, String>> electricians = [
    {
      "name": "Hossain Electric Service",
      "phone": "+880 1511-998877",
      "location": "Agargaon, Dhaka",
      "distance": "0.9 km away"
    },
    {
      "name": "Modern Electrical Repair",
      "phone": "+880 1622-887766",
      "location": "Monipur, Dhaka",
      "distance": "1.8 km away"
    },
    {
      "name": "Spark Electrician Hub",
      "phone": "+880 1733-776655",
      "location": "Taltola, Dhaka",
      "distance": "3.4 km away"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Electricians", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: electricians.length,
        itemBuilder: (context, index) {
          final electrician = electricians[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.electrical_services, color: Colors.white),
              ),
              title: Text(electrician["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(electrician["location"]!, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(electrician["phone"]!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(electrician["distance"]!, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green, size: 28),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Calling ${electrician["name"]} at ${electrician["phone"]}")),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}