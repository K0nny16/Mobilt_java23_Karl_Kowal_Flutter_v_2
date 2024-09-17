import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Widgeten som representerar registrerings sidan.
//Den är stateful eftersom att vi använder oss av FB och vi behöver kunna ändra statet.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}
//Klassen som har hand om logiken i widgeten.
class RegisterPageState extends State<RegisterPage> {
  //Instancierar FB (_för att gör det private)
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Hjälper oss att fånga upp texten från fältet.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  void _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      //Kollar ifall widgeten fortfarnde är kvar. Skyddar contextet ifall widgeten skylle skrotas under async funktionen.
      if (!mounted) return;
      //Liten notice
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully registered: ${userCredential.user!.email}')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}