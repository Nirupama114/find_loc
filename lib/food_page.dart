import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodPage extends StatefulWidget {
  final Position? userPosition;
  const FoodPage({super.key, this.userPosition});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  String _selectedCategory = "All";
  final List<String> _categories = ["All", "Kacchi", "Burger", "Pizza", "Fast Food"];

  final List<Map<String, dynamic>> restaurants = [
    {"id": "1", "name": "Kacchi Bhai (Dhanmondi)", "type": "Dhaka, Bangladesh", "category": "Kacchi", "lat": 23.7461, "lng": 90.3742, "rating": "4.8", "isFav": false},
    {"id": "2", "name": "Burger King", "type": "Premium Burgers & Fries", "category": "Burger", "lat": 23.7561, "lng": 90.3842, "rating": "4.5", "isFav": false},
    {"id": "3", "name": "Pizza Hut", "type": "Italian Crust Pizza", "category": "Pizza", "lat": 23.7661, "lng": 90.3942, "rating": "4.3", "isFav": false},
    {"id": "4", "name": "Sultans Dine", "type": "Traditional Wedding Basmati Kacchi", "category": "Kacchi", "lat": 23.7529, "lng": 90.3754, "rating": "4.9", "isFav": false},
    {"id": "5", "name": "Chillox", "type": "Juicy Beef & Chicken Burgers", "category": "Burger", "lat": 23.7441, "lng": 90.3725, "rating": "4.6", "isFav": false},
  ];

  @override
  void initState() {
    super.initState();
    _sortRestaurantsByDistance();
  }

  void _sortRestaurantsByDistance() {
    if (widget.userPosition != null) {
      restaurants.sort((a, b) {
        double distA = Geolocator.distanceBetween(widget.userPosition!.latitude, widget.userPosition!.longitude, a["lat"], a["lng"]);
        double distB = Geolocator.distanceBetween(widget.userPosition!.latitude, widget.userPosition!.longitude, b["lat"], b["lng"]);
        return distA.compareTo(distB);
      });
    }
  }

  String _calculateDistance(double destLat, double destLng) {
    if (widget.userPosition == null) return "Unknown distance";
    double distanceInMeters = Geolocator.distanceBetween(
      widget.userPosition!.latitude,
      widget.userPosition!.longitude,
      destLat,
      destLng,
    );
    return "${(distanceInMeters / 1000).toStringAsFixed(1)} km away";
  }

  Future<void> _openMapNavigation(double destLat, double destLng) async {
    final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$destLat,$destLng");

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(googleMapsUrl, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open maps: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // প্রতিবার বিল্ড হওয়ার সময় লোকেشن অনুযায়ী লিস্ট সর্ট নিশ্চিত করা
    _sortRestaurantsByDistance();

    final filteredRestaurants = _selectedCategory == "All"
        ? restaurants
        : restaurants.where((res) => res["category"] == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Restaurants", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _sortRestaurantsByDistance();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Restaurants sorted by distance!"), duration: Duration(seconds: 1)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Food Page Banner Image (সঠিক অ্যাসেট পাথ দেওয়া হয়েছে)
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
                'assets/food.jpeg', // সঠিক অ্যাসেট ফাইলের নাম
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.orange.withValues(alpha: 0.1),
                  child: const Center(
                    child: Icon(Icons.restaurant_menu, size: 50, color: Colors.orangeAccent),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: Colors.orangeAccent,
                    backgroundColor: Colors.grey[100],
                    labelStyle: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filteredRestaurants.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 10),
                  Text("No restaurants found in '$_selectedCategory'", style: const TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: filteredRestaurants.length,
              itemBuilder: (context, index) {
                final res = filteredRestaurants[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.restaurant, color: Colors.orangeAccent),
                      ),
                      title: Text(res["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(res["type"], style: TextStyle(color: Colors.grey[700])),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Colors.orangeAccent),
                              const SizedBox(width: 4),
                              Text(_calculateDistance(res["lat"], res["lng"]), style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.orangeAccent),
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => _openMapNavigation(res["lat"], res["lng"]),
                              icon: const Icon(Icons.directions, size: 16, color: Colors.orangeAccent),
                              label: const Text("Navigate to Restaurant", style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                res["isFav"] = !res["isFav"];
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(res["isFav"] ? "${res["name"]} added to favorites!" : "${res["name"]} removed!"),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Icon(res["isFav"] ? Icons.favorite : Icons.favorite_border, color: Colors.red, size: 24),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 2),
                              Text(res["rating"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
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