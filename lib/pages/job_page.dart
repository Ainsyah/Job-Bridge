import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_bridge/pages/job_details.dart';

import 'menu_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';

class JobPage extends StatefulWidget {
  final String userId;
  const JobPage({super.key, required this.userId});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final CollectionReference collRef = FirebaseFirestore.instance.collection('jobs');

  // Fetch user ID of currently logged-in user
  Future<String?> fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid; // Return current user's ID
    } else {
      print('No user is currently logged in');
      return null; // No user logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 206, 220, 232),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 206, 220, 232),
        title: const Text("Job Cards", style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            jobList(),
          ],
        ),
      ),
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search here...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              // Filter functionality can be added here
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Icon(Icons.tune),
          ),
        ],
      ),
    );
  }

  // Display job list
  Widget jobList() {
    return StreamBuilder(
      stream: collRef.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // List of jobs
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
            Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  backgroundColor: const Color.fromARGB(255, 36, 145, 169),
                ),
                onPressed: () async {
                  String? userId = await fetchUserId();

                  if (userId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailsPage(
                          documentId: data['documentId'] ?? '',
                          job_id: data['job_id'] ?? '',
                          userId: userId,
                          location: data['location'] ?? '',
                          company_id: data['company_id'] ?? '',
                          medSalary: (data['med_salary'] is int) ? data['med_salary'] : 0,
                          pay_period: data['pay_period'] ?? '',
                          formattedWorkType: data['formatted_work_type'] ?? '',
                          formattedExperienceLevel: data['formatted_experience_level'] ?? '',
                          skills_desc: data['skills_desc'] ?? '',
                          remote_allowed: data['remote_allowed'] ?? false,
                          normalizedSalary: data['normalized_salary'] ?? 0,
                          category: data['category'] ?? '',
                        ),
                      ),
                    );
                  } else {
                    print("User not logged in.");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 36, 145, 169),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Text(
                        data['title'] ?? 'No Title',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data.containsKey('company_name')
                            ? data['company_name']
                            : 'No Company Name',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage(userId: widget.userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.home, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => JobPage(userId: widget.userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.thLarge, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage(userId: widget.userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.bell, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.userCircle, color: Colors.white, size: 24),
            ),
          ],
        ),
    );
  }
}
