import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_bridge/pages/menu_page_comp.dart';
import 'package:job_bridge/pages/post_job_page.dart';
import 'package:job_bridge/pages/recruiters_page.dart';
import 'company_detail_page.dart';
import 'js_listing_page.dart';
import 'login_page.dart';

class ProfCompPage extends StatefulWidget {
  final String compId;

  const ProfCompPage({Key? key, required this.compId}) : super(key: key);

  @override
  State<ProfCompPage> createState() => _ProfCompPageState();
}

class _ProfCompPageState extends State<ProfCompPage> {
  late Future<DocumentSnapshot> userDocument;

  @override
  void initState() {
    super.initState();
    userDocument = FirebaseFirestore.instance
        .collection('company')
        .doc(widget.compId)
        .get(); // Fetch user document based on userId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text("Profile", style: TextStyle(color: Color.fromARGB(255, 5, 52, 92), fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userDocument,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading user information"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Company not found"));
          }

          // Extract user data
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String compName = userData['comp_name'] ?? 'No Company Name';
          final String email = userData['email'] ?? 'No Company Email';
          final dynamic compDesc= userData['comp_desc'] ?? 'No Company Description';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name on the left and Icon on the right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        compName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 5, 52, 92),
                        ),
                      ),
                      const Spacer(), // This will push the icon to the right
                      const Icon(
                        FontAwesomeIcons.userAlt,
                        size: 80,
                        color: Color.fromARGB(255, 5, 52, 92),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        compDesc,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 5, 52, 92),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // User Information Header
                  const Text(
                    'Company Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 52, 92)),
                  ),
                  const SizedBox(height: 15),

                  // Email Information
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompanyDetailPage(compId: widget.compId),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 242, 236, 233),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.email_outlined, color: Color.fromARGB(255, 5, 52, 92)),
                          const SizedBox(width: 12),
                          Text(
                            email,
                            style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 5, 52, 92)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 5, 52, 92)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Logout Button
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 5, 52, 92),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPageComp(compId: widget.compId)),
                );
              },
              child: const Icon(FontAwesomeIcons.home, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => JsListingPage(compId: widget.compId)),
                );
              },
              child: const Icon(FontAwesomeIcons.fileLines, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PostJobPage(compId: widget.compId)),
                );
              },
              child: const Icon(FontAwesomeIcons.briefcase, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfCompPage(compId: widget.compId)),
                );
              },
              child: const Icon(FontAwesomeIcons.userCircle, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
