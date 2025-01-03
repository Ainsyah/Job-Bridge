import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'job_page.dart';
import 'menu_page.dart';
import 'notification_page.dart';
import 'profile_page.dart';
import 'recruiters_page.dart';

class JobDetailsPage extends StatelessWidget {
  final String documentId;
  final String jobId;
  final String userId;

  const JobDetailsPage({
    super.key,
    required this.documentId,
    required this.jobId,
    required this.userId,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuPage(userId: userId)),
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
          MaterialPageRoute(builder: (context) => ProfilePage(userId: userId)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference jobRef = FirebaseFirestore.instance.collection('jobs');
    final CollectionReference companyRef = FirebaseFirestore.instance.collection('company');

    const TextStyle headerStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 17, 72, 84),
    );

    const TextStyle normalTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 17, 72, 84),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: jobRef.doc(documentId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> jobSnapshot) {
          if (jobSnapshot.hasError) {
            return const Center(child: Text('Error fetching job data'));
          }
          if (!jobSnapshot.hasData || !jobSnapshot.data!.exists) {
            return const Center(child: Text('Job does not exist'));
          }

          var jobData = jobSnapshot.data!;
          return Container(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobData['title'],
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(jobData['desc'], style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 20),
                  const Text('CONTACT INFORMATION', style: headerStyle),
                  const SizedBox(height: 10),
                  StreamBuilder<DocumentSnapshot>(
                    stream: companyRef.doc(jobId).snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> compSnapshot) {
                      if (compSnapshot.hasError) {
                        return const Text('Error fetching organization data');
                      }
                      if (!compSnapshot.hasData || !compSnapshot.data!.exists) {
                        return const Text('Organization details not available');
                      }
                      var compData = compSnapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Company Name: ${compData['compName']}', style: normalTextStyle),
                          const SizedBox(height: 10),
                          Text('Email: ${compData['compEmail']}', style: normalTextStyle),
                          const SizedBox(height: 10),
                          Text('Location: ${compData['compLocation']}', style: normalTextStyle),
                        ],
                      );
                    },
                  ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage(userId: userId)),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => RecruitersPage(userId: userId)),
                );
              },
              child: const Icon(FontAwesomeIcons.bell, color: Colors.white, size: 24),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userId: userId)),
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
