import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicalPage extends StatefulWidget {
  final Position? userPosition;
  const MedicalPage({super.key, this.userPosition});

  @override
  State<MedicalPage> createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  bool _isLoading = false;

  final List<Map<String, dynamic>> _hospitalsList = [
    {"name": "Dhaka Medical College Hospital", "info": "Emergency & General", "lat": 23.7261, "lng": 90.3982, "phone": "+880255165001", "type": "Hospital"},
    {"name": "Evercare Hospital Dhaka", "info": "24/7 Specialized Healthcare", "lat": 23.8124, "lng": 90.4320, "phone": "10678", "type": "Hospital"},
    {"name": "Lazz Pharma (Dhanmondi)", "info": "24/7 Medicine Pharmacy", "lat": 23.7520, "lng": 90.3800, "phone": "+8801711112233", "type": "Pharmacy"},
    {"name": "Square Hospital", "info": "ICU & Specialized Care", "lat": 23.7532, "lng": 90.3818, "phone": "10616", "type": "Hospital"},
  ];

  @override
  void initState() {
    super.initState();
    _fetchOnlineMedicalData();
  }

  Future<void> _fetchOnlineMedicalData() async {
    setState(() => _isLoading = true);
    try {
      if (widget.userPosition != null) {
        _hospitalsList.sort((a, b) {
          double distA = Geolocator.distanceBetween(widget.userPosition!.latitude, widget.userPosition!.longitude, a["lat"], a["lng"]);
          double distB = Geolocator.distanceBetween(widget.userPosition!.latitude, widget.userPosition!.longitude, b["lat"], b["lng"]);
          return distA.compareTo(distB);
        });
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getDistance(double lat, double lng) {
    if (widget.userPosition == null) return "Distance loading...";
    double meters = Geolocator.distanceBetween(widget.userPosition!.latitude, widget.userPosition!.longitude, lat, lng);
    return "${(meters / 1000).toStringAsFixed(1)} km away";
  }

  Future<void> _openMapNavigation(double destLat, double destLng) async {
    final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng&travelmode=driving";
    final Uri url = Uri.parse(googleMapsUrl);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not open maps navigation."), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not initiate call service."), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _contactService(BuildContext context, String name, String phone, double lat, double lng) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text("Emergency Contact: $phone", style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () {
                      Navigator.pop(context);
                      _makePhoneCall(phone);
                    },
                    icon: const Icon(Icons.call, color: Colors.white),
                    label: const Text("Call Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () {
                      Navigator.pop(context);
                      _openMapNavigation(lat, lng);
                    },
                    icon: const Icon(Icons.directions, color: Colors.white),
                    label: const Text("Get Directions", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Medical Services", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchOnlineMedicalData,
          )
        ],
      ),
      body: Column(
        children: [
          // Medical Page Banner Image
          Container(
            height: 160,
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/medicine.jpeg', // সঠিক অ্যাসেট পাথ দেওয়া হয়েছে
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.blue.withValues(alpha: 0.1),
                  child: const Center(
                    child: Icon(Icons.local_hospital, size: 50, color: Colors.blueAccent),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: _hospitalsList.length,
              itemBuilder: (context, index) {
                final hosp = _hospitalsList[index];
                final isPharmacy = hosp["type"] == "Pharmacy";

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isPharmacy ? Colors.teal.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                      child: Icon(
                        isPharmacy ? Icons.local_pharmacy : Icons.local_hospital,
                        color: isPharmacy ? Colors.teal : Colors.redAccent,
                      ),
                    ),
                    title: Text(hosp["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(hosp["info"]),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(_getDistance(hosp["lat"], hosp["lng"]), style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_circle_right_outlined, color: Colors.blueAccent, size: 30),
                      onPressed: () => _contactService(context, hosp["name"], hosp["phone"], hosp["lat"], hosp["lng"]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}