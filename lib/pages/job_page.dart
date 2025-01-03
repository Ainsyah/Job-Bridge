import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_bridge/pages/job_details.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final CollectionReference collRef =
      FirebaseFirestore.instance.collection('jobs');

  Future<String?> fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;  // Return the current logged-in user's ID
    } else {
      print('No user is currently logged in');
      return null;
    }
  }

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

  Widget jobList() {
    return StreamBuilder(
      stream: collRef.snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
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
                          documentId: documentSnapshot['documentId'],  // Use documentSnapshot to get the fields
                          jobId: documentSnapshot['jobId'] ?? '', 
                          userId: userId,
                        ),
                      ),
                    );
                  } else {
                    // Handle the case where userId is not found (e.g., show an error message)
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
                        documentSnapshot['title'],
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        documentSnapshot['desc'],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 236, 233),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 236, 233),
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
}
