import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_bridge/pages/post_job_page.dart';
import 'job_page.dart';
import 'menu_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';

class RecruitersPage extends StatefulWidget {
  final String userId;
  const RecruitersPage({super.key, required this.userId});

  @override
  _RecruitersPageState createState() => _RecruitersPageState();
}

class _RecruitersPageState extends State<RecruitersPage> {
  int _selectedIndex = 2;  // Set default to NotificationPage

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuPage(userId: widget.userId)),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => JobPage()),
        );
        break;
      case 2:
        // No action needed, already on the NotificationPage
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 236, 233),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 236, 233),
        title: const Text('Recruiters'),
        elevation: 0,
      ),
      body: SingleChildScrollView( // Added ScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 170,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Recruiters hiring in Malaysia",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostJobPage(userId: widget.userId)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      backgroundColor: Colors.white, // Text color
                    ),
                    child: Text(
                      "Do you offer jobs?",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.industry,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Top Industry",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text("Content for container 1"),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text("Content for container 2"),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text("Content for container 3"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  MaterialPageRoute(builder: (context) => JobPage()),
                );
              },
              child: const Icon(FontAwesomeIcons.thLarge, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage(userId: widget.userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.bell, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)),
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
