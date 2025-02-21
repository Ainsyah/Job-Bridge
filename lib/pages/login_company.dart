import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_bridge/components/my_button.dart';
import 'package:job_bridge/components/my_textfield.dart';
import 'package:job_bridge/components/square_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_bridge/pages/start_page_sec.dart';
import 'menu_page.dart';
import 'menu_page_comp.dart';

class LoginCompany extends StatefulWidget {
  final TextEditingController? usernameController;
  final TextEditingController? passwordController;

  const LoginCompany({
    super.key,
    this.usernameController,
    this.passwordController,
  });

  @override
  State<LoginCompany> createState() => _LoginCompanyState();
}

class _LoginCompanyState extends State<LoginCompany> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  void initState() {
    super.initState();
    usernameController = widget.usernameController ?? TextEditingController();
    passwordController = widget.passwordController ?? TextEditingController();
  }

  // Sign user in method
  void signUserIn() async {
    // Show loading circle
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal of the loading dialog
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Ensure fields are not empty
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Navigator.pop(context);
      showErrorMessage('Please fill in all fields.');
      return;
    }

    // Try sign in
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('company')
          .where('username', isEqualTo: usernameController.text)
          .get();

      if (userDoc.docs.isEmpty) {
        Navigator.pop(context); // Close loading dialog
        // Username not found
        showErrorMessage('Username not found.');
        return;
      }

      // Get the email associated with the username
      String email = userDoc.docs.first['email'];
      String compId = userDoc.docs.first.id;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );

      Navigator.pop(context);

      showErrorMessage('Login Successful!'); // Success message

      // Navigate to home page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MenuPageComp(
            compId: compId,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading dialog
      String errorMessage = e.message ?? "An unknown error occurred";
      showErrorMessage(errorMessage); // Show the specific error message
    }
  }

  // Helper function to show an error dialog
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 206, 220, 232),
          title: Text(
            message,
            style: const TextStyle(
              color:  Color.fromARGB(255, 5, 52, 92),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK', style: TextStyle(color:  Color.fromARGB(255, 5, 52, 92))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 52, 92),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                const Text(
                  'Job Bridge',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 37,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Username textfield
                MyTextfield(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Password textfield
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // Forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: const Color.fromARGB(255, 230, 229, 229)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Sign in button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50),
                    foregroundColor: const Color.fromARGB(255, 5, 52, 92),
                    backgroundColor: const Color.fromARGB(255, 206, 220, 232),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle:
                        TextStyle(fontSize: 20), // Set your desired font size
                  ),
                  onPressed: signUserIn,
                  child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold),),
                ),

                const SizedBox(height: 50),

                // Or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: const Color.fromARGB(255, 230, 229, 229),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: const Color.fromARGB(255, 230, 229, 229)),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Not a member? Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: const Color.fromARGB(255, 230, 229, 229)),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StartPageSec(),
                          ),
                        );
                      },
                      child: const Text(
                        ' Register Now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}