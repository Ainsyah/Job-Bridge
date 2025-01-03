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
  const MenuPage({required this.userId});

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
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('jobs').get();
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
      backgroundColor: const Color.fromARGB(255, 242, 236, 233),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildReminder(),
                const SizedBox(height: 16),
                _buildStatistics(),
                const SizedBox(height: 16),
                _buildJobSection(context),
                const SizedBox(height: 100), // Space for bottom navigation bar
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
        color: const Color.fromARGB(255, 242, 236, 233),
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
                    size: 30, // Icon size
                    color: Colors.black, // Icon color
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome back",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      _userData != null && _userData!['name'] != null? _userData!['name'] : "User", // Null check for user data
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
            child: const FaIcon(FontAwesomeIcons.bell, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildReminder() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 100,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.orange[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reminder",
                style: TextStyle(
                  color: Colors.orange[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Text(
                "Interview at Zoom in 1 hour.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          Text(
            "4:30 PM",
            style: TextStyle(
              color: Colors.orange[600],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatisticCard("546", "Views", Colors.purple),
              const SizedBox(width: 16),
              _buildStatisticCard("84", "Interactions", Colors.orange),
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
              jobId: job['jobId'] ?? '',
              userId: widget.userId, // Pass widget.userId
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 70, 179, 164),
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

  Widget _buildStatisticCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey)),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => JobPage()),
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
