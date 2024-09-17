import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class EnterInfoPage extends StatefulWidget {
  const EnterInfoPage({super.key});

  @override
  EnterInfoPageState createState() => EnterInfoPageState();
}

class EnterInfoPageState extends State<EnterInfoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String gender = 'Male';
  double age = 25;

  void _submitInfo() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _dbRef.child('users/${user.uid}/info').set({
        'name': _nameController.text.trim(),
        'age': age.toInt(),
        'gender': gender,
        'address': _addressController.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Information submitted successfully!')),
      );
      Navigator.pushReplacementNamed(context, '/info');
    }
  }

  void _logout() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Information'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            // Age Slider
            Text('Age: ${age.round()}', style: const TextStyle(fontSize: 18)),
            Slider(
              value: age,
              min: 0,
              max: 100,
              divisions: 100,
              label: age.round().toString(),
              onChanged: (double newValue) {
                setState(() {
                  age = newValue;
                });
              },
            ),
            const SizedBox(height: 10),
            // Gender Radio buttons
            const Text('Gender:', style: TextStyle(fontSize: 18)),
            RadioListTile<String>(
              title: const Text('Male'),
              value: 'Male',
              groupValue: gender,
              onChanged: (String? value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Female'),
              value: 'Female',
              groupValue: gender,
              onChanged: (String? value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: _submitInfo,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            // Navigate to InfoPage Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/info');
              },
              child: const Text('View Saved Info'),
            ),
            const SizedBox(height: 20),
            // Logout Button
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}