import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_bridge/components/my_textfield.dart';
import 'package:job_bridge/pages/menu_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_bridge/pages/register_details.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final linkedinURLController = TextEditingController();
  bool _isWillingToRelocate = false;

  // Sign user up method
  void signUserUp() async {
    // Check if email or password is empty
    if (emailController.text.isEmpty ||
      passwordController.text.isEmpty ||
      confirmPasswordController.text.isEmpty ||
      usernameController.text.isEmpty ||
      fullNameController.text.isEmpty ||
      phoneController.text.isEmpty ||
      addressController.text.isEmpty) {
    showErrorMessage('Please fill in all fields');
    return;
  }

    if (passwordController.text != confirmPasswordController.text) {
      showErrorMessage('Passwords do not match. Please try again.');
      return;
    }

    // Show loading circle
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing on tap
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Try creating the user
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Get the user's UID
      String uid = userCredential.user!.uid;

      // Create a Firestore reference
      CollectionReference ref =
          FirebaseFirestore.instance.collection('users');

      // Save user data to Firestore
      await ref.doc(uid).set({
        'email': emailController.text,
        'username': usernameController.text,
        'fullname': fullNameController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'linkedin': linkedinURLController.text,
        'relocate': _isWillingToRelocate,
      });

      Navigator.of(context).pop(); // Close the loading dialog
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration successful!')));

      // Navigate to MenuPage after successful registration
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => RegisterDetailsPage(uid: uid),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Pop the loading circle
      Navigator.of(context).pop(); // Close the loading dialog
      // Show error message
      showErrorMessage(e.message ?? "An error occurred");
    }
  }

  // Error message to the user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 71, 62, 59),
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 236, 233),
      body: SafeArea(
        child: Center(
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                
                    // Logo
                    const Icon(
                      Icons.phone_android,
                      size: 50,
                    ),
                
                    const SizedBox(height: 30),
                
                    // Let's create an account for you
                    Text(
                      'Let\'s create an account for you!',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                
                    const SizedBox(height: 10),
                
                    // Fullname
                    MyTextfield(
                      controller: fullNameController,
                      hintText: 'Fullname',
                      obscureText: false,
                    ),
                
                    const SizedBox(height: 10),
                
                    // Username textfield
                    MyTextfield(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false,
                    ),
                
                    const SizedBox(height: 10),
                
                    // Address
                    MyTextfield(
                      controller: addressController,
                      hintText: 'Address',
                      obscureText: false,
                    ),
            
                    const SizedBox(height: 10),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isWillingToRelocate,
                            onChanged: (value) {
                              setState(() {
                                _isWillingToRelocate = value!;
                              });
                            },
                          ),
                          const Text("Willing to Relocate"),
                        ],
                      ),
                    ),
                
                    const SizedBox(height: 10),
                
                    // Phone
                    MyTextfield(
                      controller: phoneController,
                      hintText: 'Phone',
                      obscureText: false,
                    ),
                
                    const SizedBox(height: 10),
                
                    MyTextfield(
                      controller: linkedinURLController,
                      hintText: 'Linked In Profile',
                      obscureText: false,
                    ),
                
                    const SizedBox(height: 10),
                
                    // Email textfield
                    MyTextfield(
                      controller: emailController,
                      hintText: 'Email',
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
                
                    // Confirm password textfield
                    MyTextfield(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),
                
                    const SizedBox(height: 25),
                
                    // Sign up button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 50),
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 71, 62, 59),
                        textStyle: TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: signUserUp,
                      child: const Text('Sign Up'),
                    ),
                
                    const SizedBox(height: 30),
                
                    // Or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.grey[700]),
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
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
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
                
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
