import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  InfoPageState createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  String name = '';
  String age = '';
  String gender = '';
  String address = '';

  // Metod för att hämta användarens information från Firebase
  void _getUserInfo() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        final DatabaseEvent event = await _dbRef.child('users/${user.uid}/info').once();
        if (event.snapshot.value != null) {
          final data = event.snapshot.value as Map;
          setState(() {
            name = data['name'] ?? 'No name found!';
            age = data['age']?.toString() ?? 'No age found!';
            gender = data['gender'] ?? 'No gender found!';
            address = data['address'] ?? 'No adress found!';
          });
        }
      } catch (e) {
        debugPrint("Error $e");
      }
    }
  }

  // Metod för att logga ut användaren
  void _logout() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }
  @override
  void initState() {
    super.initState();
    _getUserInfo();  // Hämta användarens information när sidan laddas
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: $name', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Age: $age', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Gender: $gender', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Address: $address', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/enterInfo');  // Navigera till sidan för att fylla i information
              },
              child:const Text('Enter/Edit Information'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,  // Logga ut användaren
              child:const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}