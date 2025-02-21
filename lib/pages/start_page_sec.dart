import 'package:flutter/material.dart';
import 'package:job_bridge/pages/reg_company.dart';
import 'login_company.dart';
import 'login_page.dart';
import 'reg_page.dart';

class StartPageSec extends StatelessWidget {
  const StartPageSec({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 52, 92), // Dark background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo or Title
              Text(
                'Job Bridge',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Subtitle
              Text(
                'Choose your registration type',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Register as Job Seeker Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegPage(), // Job seeker page
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                  foregroundColor: const Color.fromARGB(255, 5, 52, 92),
                  backgroundColor: Color.fromARGB(255, 206, 220, 232),
                  textStyle: TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: Icon(Icons.person, color: const Color.fromARGB(255, 5, 52, 92)),
                label: const Text(
                  'Register as Job Seeker',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // Register as Company Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegCompanyPage(), // Company page
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                  foregroundColor: const Color.fromARGB(255, 5, 52, 92),
                  backgroundColor: Color.fromARGB(255, 206, 220, 232),
                  textStyle: TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: Icon(Icons.business, color: const Color.fromARGB(255, 5, 52, 92)),
                label: const Text(
                  'Register as Company',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Already have an account?',
                      style: TextStyle(color: const Color.fromARGB(255, 230, 229, 229)),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
  onTap: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login as'),
          content: Text('Please select your role to continue.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(), // Job seeker login page
                  ),
                );
              },
              child: Text('Job Seeker'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginCompany(), // Company login page
                  ),
                );
              },
              child: Text('Company'),
            ),
          ],
        );
      },
    );
  },
  child: const Text(
    ' Login Now',
    style: TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
    ),
  ),
),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
