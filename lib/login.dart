import 'package:flutter/material.dart';
import 'package:pawfect_match_app/create_profile.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Welcome to Pawfect", style: TextStyle(
            color: Colors.purple,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 30,),
          TextField(
          decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0)
              ),
            prefixIcon: const Align(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Icon(Icons.person),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0)
              ),
            prefixIcon: const Align(
              heightFactor: 1.0,
                widthFactor: 1.0,
              child: Icon(Icons.password),
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 12),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[600]),
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              ),
            )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Don't have an account?",style: TextStyle(fontSize: 14)),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileCreationPage()),
              );
            }, child: Text("SignUp", style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo[400],
            )
            )
            )
          ],
        ),
          Text("Forgot Password", style: TextStyle(fontSize: 12,
            color: Colors.indigo[400],
            decoration: TextDecoration.underline),
          )
      ],
      )
    );
  }
}
