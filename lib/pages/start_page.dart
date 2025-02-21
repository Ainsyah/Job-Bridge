import 'package:flutter/material.dart';
import 'package:job_bridge/pages/start_page_sec.dart';
import 'login_page.dart';
import 'register_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isLoginPage = true; // Toggle between Login and Registration

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
      backgroundColor: const Color.fromARGB(255, 5, 52, 92),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 52, 92),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          // Navigate to Login page when user taps anywhere
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StartPageSec()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              //const SizedBox(height: 10),
              Text(
                "Job Bridge",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Connecting Skills to Opportunities",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
