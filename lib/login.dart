import 'package:flutter/material.dart';
import 'package:pawfect_match_app/create_profile.dart';
import 'package:pawfect_match_app/swiping_page.dart';
import 'package:pawfect_match_app/user_repo.dart';

class Login extends StatelessWidget {
  final UserRepository userRepository;

  const Login({Key? key, required this.userRepository}) : super(key: key);

  void showLoginFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Please check your username, password and try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Welcome to Pawfect", style: TextStyle(color: Colors.purple, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              prefixIcon: const Icon(Icons.password),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final profile = await userRepository.getUser(usernameController.text);
              if (profile == null || profile.password != passwordController.text) {
                showLoginFailedDialog(context);
              } else {
                print("login bypass");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SwipingMatchingPage(userName: usernameController.text, userRepository: userRepository,)));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[600]),
            child: const Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Don't have an account?", style: TextStyle(fontSize: 14)),
              TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileCreationPage(userRepository: userRepository,))),
                child: Text("SignUp", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo[400])),
              ),
            ],
          ),
          Text("Forgot Password", style: TextStyle(fontSize: 12, color: Colors.indigo[400], decoration: TextDecoration.underline)),
        ],
      ),
    );
  }
}