import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_bridge/pages/saved_jobs.dart';
import 'package:job_bridge/pages/skills_page.dart';
import 'add_rating.dart';
import 'job_postings.dart';
import 'login_page.dart';
import 'menu_page.dart';
import 'user_details_page.dart';

class ProfPage extends StatefulWidget {
  final String userId;

  const ProfPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfPage> createState() => _ProfPageState();
}

class _ProfPageState extends State<ProfPage> {
  late Future<DocumentSnapshot> userDocument;

  @override
  void initState() {
    super.initState();
    userDocument = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
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
            return const Center(child: Text("User not found"));
          }

          // Extract user data
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String fullname = userData['fullname'] ?? 'No Name';
          final String email = userData['email'] ?? 'No Email';
          final dynamic skills = userData['skills'] ?? 'No Skills';
          List<Widget> skillWidgets = [];
          String skillsText = '';

          if (skills is List) {
            // If 'skills' is a list, map each skill to a Chip widget
            skillWidgets = skills.map<Widget>((skill) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                child: Chip(
                  label: Text(
                    skill,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color.fromARGB(255, 5, 52, 92),
                ),
              );
            }).toList();
          }

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
                        fullname,
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
                  const SizedBox(height: 32),

                  // User Information Header
                  const Text(
                    'User Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 52, 92)),
                  ),
                  const SizedBox(height: 15),

                  // Email Information
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailPage(userId: widget.userId),
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
                  Text(
                    'Skills',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 52, 92)),
                  ),
                  const SizedBox(height: 10),

                  // Skills Information
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailPage(userId: widget.userId),
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
        //const Icon(Icons.school, color: Color.fromARGB(255, 5, 52, 92)),
        Expanded(
          child: Wrap(
            spacing: 8.0,  // Horizontal spacing between the chips
            runSpacing: 4.0,  // Vertical spacing between the chips
            children: skillWidgets.isNotEmpty
                ? skillWidgets
                : [Text('No Skills', style: TextStyle(color: Colors.grey))],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 5, 52, 92)),
      ],
    ),
  ),
),
                  const SizedBox(height: 32),

                  // User Rating Header
                  const Text(
                    'Rate A Job',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 52, 92)),
                  ),
                  const SizedBox(height: 15),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRating(userId: widget.userId),
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
                          const Icon(Icons.edit_outlined, color: Color.fromARGB(255, 5, 52, 92)),
                          const SizedBox(width: 12),
                          Text(
                            'Add rating',
                            style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 5, 52, 92)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 5, 52, 92)),
                        ],
                      ),
                    ),
                  ),

                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Show the rating dialog
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) => AddRating(userId: widget.userId),
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Color.fromARGB(255, 5, 52, 92),
                  //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  //   ),
                  //   child: const Text("Add Rating", style: TextStyle(fontSize: 16, color: Colors.white)),
                  // ),

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
                  MaterialPageRoute(builder: (context) => MenuPage(userId: widget.userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.home, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => JobPostingsPage(userId: widget.userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.solidClipboard, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SavedJobsPage(userId: widget.userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.bookmark, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfPage(userId: widget.userId)),
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
