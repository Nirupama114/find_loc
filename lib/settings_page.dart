import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // প্রাইভেসি পলিসি বা ওয়েব লিংক ওপেন করার জন্য
import 'main.dart'; // গ্লোবাল থিম টগল অ্যাক্সেস করার জন্য MyApp ইম্পোর্ট করা হয়েছে

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // নোটিফিকেশন অন/অফ করার জন্য লাইভ স্টেট ভ্যারিয়েবল
  bool _isNotificationEnabled = true;

  // ১. এডিট প্রোফাইল ফাংশনালিটি (ডায়ালগ পপ-আপ)
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: "Nirupama Yeasmin Nisa");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: "Full Name",
            prefixIcon: Icon(Icons.person_outline, color: Colors.orangeAccent),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Profile updated to: ${nameController.text}"),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ২. পাসওয়ার্ড পরিবর্তন করার কার্যকরী ডায়ালগ
  void _showChangePasswordDialog() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Current Password"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
            onPressed: () {
              if (oldPassController.text.isNotEmpty && newPassController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Password updated successfully!"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ৪. প্রাইভেসি পলিসি লিংক ওপেন করার ফাংশন
  Future<void> _openPrivacyPolicy() async {
    final Uri url = Uri.parse('https://www.google.com'); // এখানে আপনার আসল পলিসি লিংক বসাতে পারেন
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not open Privacy Policy link.")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // বর্তমান থিম মোড চেক করা (Dark না Light)
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          // Account Settings Section
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Text(
              "Account Settings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),

          _buildSettingsTile(
              Icons.person,
              "Edit Profile",
              "Change your name or image",
              onTap: _showEditProfileDialog
          ),

          _buildSettingsTile(
              Icons.lock,
              "Change Password",
              "Update your login security",
              onTap: _showChangePasswordDialog
          ),

          const Divider(height: 30),

          // Preferences Section
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Text(
              "Preferences",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),

          // নতুন যুক্ত করা হয়েছে: Dark Mode / Light Mode টগল সুইচ
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 8),
            child: SwitchListTile(
              secondary: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Colors.orangeAccent,
              ),
              title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(isDarkMode ? "Switch to Normal (Light) Mode" : "Switch to Dark Mode"),
              activeThumbColor: Colors.orangeAccent,
              value: isDarkMode,
              onChanged: (bool value) {
                // main.dart এর থিম টগল মেথড কল করা হলো
                MyApp.of(context)?.toggleTheme(value);
              },
            ),
          ),

          // নোটিফিকেশন টগল বাটন (Switch যুক্ত করা হয়েছে)
          Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 8),
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications, color: Colors.orangeAccent),
              title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Turn on/off app alerts"),
              activeThumbColor: Colors.orangeAccent,
              value: _isNotificationEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isNotificationEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value ? "Notifications Enabled" : "Notifications Disabled"),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),

          _buildSettingsTile(
              Icons.privacy_tip,
              "Privacy Policy",
              "View terms and conditions",
              onTap: _openPrivacyPolicy
          ),
        ],
      ),
    );
  }

  // কাস্টম রিইউজেবল লিস্ট টাইল উইজেট
  Widget _buildSettingsTile(IconData icon, String title, String subtitle, {required VoidCallback onTap}) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.orangeAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}