import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_bridge/pages/post_job_page.dart';
import 'job_seeker_report.dart';
import 'menu_page_comp.dart';
import 'prof_comp_page.dart';
import 'recruiters_page.dart';

class JsListingPage extends StatefulWidget {
  final String compId;

  const JsListingPage({
    Key? key,
    required this.compId,
  });

  @override
  State<JsListingPage> createState() => _JsListingPageState();
}

class _JsListingPageState extends State<JsListingPage> {
  final CollectionReference collRef =
      FirebaseFirestore.instance.collection('company');

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('List of Job Seekers', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 5, 52, 92))),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching job seekers"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No job seekers found"));
          }

          final jobSeekers = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 30.0),
            itemCount: jobSeekers.length,
            itemBuilder: (context, index) {
              final jobSeeker = jobSeekers[index].data() as Map<String, dynamic>;
              final jobSeekerId = jobSeekers[index].id;
              final fullName = jobSeeker['fullname'] ?? "Unknown Name";
              final email = jobSeeker['email'] ?? "Unknown Email";

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobSeekerReport(
                        userId: jobSeekerId, compId: '',
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(email),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              );
            },
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
