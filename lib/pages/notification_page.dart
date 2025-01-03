import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'job_page.dart';
import 'menu_page.dart';
import 'profile_page.dart';

class NotificationPage extends StatefulWidget {
  final String userId;
  const NotificationPage({super.key, required this.userId});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
        title: const Text('Notifications'),
        elevation: 0,
        //centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'This is the notification page',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
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
      ),
    );
  }
}
