// Baran
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: HomePage()));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Pawfect!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_logIn(), _signUp()],
        ),
      ),
    );
  }

  Widget _logIn() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0))),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0))),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
            onPressed: () {},
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 20),
            )
        ),
        const Text("Don't have an account? Sign Up")
      ],
    );
  }

  Widget _signUp() {
    return const Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            hintText: "Enter your name",
          ),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "Enter your Dog's Breed",
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Age ",
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: "Weight "),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
