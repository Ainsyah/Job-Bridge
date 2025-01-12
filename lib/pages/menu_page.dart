import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'job_details.dart';
import 'profile_page.dart';
import 'notification_page.dart';
import 'recruiters_page.dart';
import 'job_page.dart';

class MenuPage extends StatefulWidget {
  final String userId; // Corrected naming convention
  const MenuPage({required this.userId, Key? key}) : super(key: key);

  @override
  _MenuPage createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  List<Map<String, dynamic>> _jobs = []; // To hold fetched job data
  Map<String, dynamic>? _userData; // To hold user data

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchJobs();
  }

  Future<String?> fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;  // Return the current logged-in user's ID
    } else {
      print('No user is currently logged in');
      return null;
    }
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>;
        });
      } else {
        print("User document does not exist.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> fetchJobs() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('user_interaction', isEqualTo: widget.userId) // Filter based on user's interactions
          .get();

      setState(() {
        _jobs = snapshot.docs.map((doc) {
          return {
            'documentId': doc.id,
            ...doc.data() as Map<String, dynamic>,
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching jobs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 206, 220, 232),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildStatistics(),
                const SizedBox(height: 16),
                _buildJobSection(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 5, 52, 92),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)),
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[200], // Optional, to set a background color
                  child: Icon(
                    Icons.person,
                    size: 35, // Icon size
                    color: Colors.black, // Icon color
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome back",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      _userData != null && _userData!['username'] != null? _userData!['username'] : "User", // Null check for user data
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage(userId: widget.userId)),
              );
            },
            child: const FaIcon(FontAwesomeIcons.bell, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Statistics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("View all", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobSection(BuildContext context) {
    return _jobs.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Suggested Jobs For You',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 17, 72, 84),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                _buildJobList(),
              ],
            ),
          );
  }

  Widget _buildJobList() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _jobCard(job),
          );
        },
      ),
    );
  }

  Widget _jobCard(Map<String, dynamic> job) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => JobDetailsPage(
              documentId: job['documentId'],
              job_id: job['jobId'] ?? '',
              userId: widget.userId,
              location: job['location'],
              company_id: job['company_id'],
              medSalary: job['med_salary'],
              pay_period: job['pay_period'],
              formattedWorkType: job['formatted_work_type'],
              formattedExperienceLevel: job['formatted_experience_level'],
              skills_desc: job['skills_desc'],
              remote_allowed: job['remote_allowed'],
              normalizedSalary: job['normalized_salary'],
              category: job['category'], // Pass widget.userId
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 221, 228),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              job['title'] ?? 'Untitled Job',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              job['desc'] ?? 'No description available',
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
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
