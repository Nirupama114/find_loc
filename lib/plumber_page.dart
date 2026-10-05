import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PlumberPage extends StatefulWidget {
  final Position? userPosition;
  const PlumberPage({super.key, this.userPosition});

  @override
  State<PlumberPage> createState() => _PlumberPageState();
}

class _PlumberPageState extends State<PlumberPage> {
  // ডামি প্লাম্বার লিস্ট (এখানে রিয়েল API বা Database ডেটাও যুক্ত করতে পারবেন)
  final List<Map<String, String>> plumbers = [
    {
      "name": "Rahim Plumber Service",
      "phone": "+880 1711-223344",
      "location": "Mirpur 10, Dhaka",
      "distance": "1.2 km away"
    },
    {
      "name": "Al-Amin Pipe Fitting & Sanitary",
      "phone": "+880 1822-334455",
      "location": "Kazipara, Dhaka",
      "distance": "2.5 km away"
    },
    {
      "name": "Quick Fix Plumber",
      "phone": "+880 1933-445566",
      "location": "Sheorapara, Dhaka",
      "distance": "3.1 km away"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Plumbers", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: plumbers.length,
        itemBuilder: (context, index) {
          final plumber = plumbers[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: const CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                child: Icon(Icons.plumbing, color: Colors.white),
              ),
              title: Text(plumber["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(plumber["location"]!, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(plumber["phone"]!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(plumber["distance"]!, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green, size: 28),
                onPressed: () {
                  // এখানে সরাসরি কল করার ফাংশন বা ডায়ালগ দিতে পারেন
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Calling ${plumber["name"]} at ${plumber["phone"]}")),
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