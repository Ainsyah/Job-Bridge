import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isLoginPage = true; // Toggle between Login and Registration

  void _toggleLoginRegister() {
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }

  void _proceed() {
    if (isLoginPage) {
      // Navigate to Login page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      // Navigate to Registration page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to FeedItForward"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Are you here to search for jobs?"
            ),
            const Text(
              "Create a New Account or Login to Continue",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _proceed,
              child: Text(isLoginPage ? "Login" : "Register"),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _toggleLoginRegister,
              child: Text(isLoginPage
                  ? "Don't have an account? Register here"
                  : "Already have an account? Login here"),
            ),
          ],
        ),
      ),
    );
  }
}
