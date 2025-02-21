import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_bridge/pages/chat_company.dart';
import 'package:job_bridge/pages/chat_company_detail.dart';
import 'package:job_bridge/pages/chat_user.dart';
import 'chat_detail.dart';
import 'job_details.dart';
import 'js_listing_page.dart';
import 'post_job_page.dart';
import 'prof_comp_page.dart';
import 'recruiters_page.dart';

class MenuPageComp extends StatefulWidget {
  final String compId;

  const MenuPageComp({
    Key? key,
    required this.compId,
  });

  @override
  State<MenuPageComp> createState() => _MenuPageCompState();
}

class _MenuPageCompState extends State<MenuPageComp> {
  final usersRef = FirebaseFirestore.instance.collection('users');
  late Future<DocumentSnapshot> userDocument;

  @override
  void initState() {
    super.initState();
      userDocument = FirebaseFirestore.instance
        .collection('company')
        .doc(widget.compId)
        .get(); 
  }

  Future<int> _getJobSeekerCount() async {
    QuerySnapshot querySnapshot = await usersRef.get();
    return querySnapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          "Job Bridge",
          style: TextStyle(
              color: Color.fromARGB(255, 5, 52, 92),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 5, 52, 92),
                  borderRadius: BorderRadius.circular(0),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfCompPage(compId: widget.compId)),
                              );
                            },
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('company')
                                  .doc(widget.compId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return const Icon(Icons.error);
                                }
                                if (!snapshot.hasData ||
                                    !snapshot.data!.exists) {
                                  return const Icon(Icons.error);
                                }

                                final userData =
                                    snapshot.data!.data() as Map<String, dynamic>;
                                final String fullname =
                                    userData['comp_name'] ?? 'No Name';

                                return Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      child: const Icon(Icons.person,
                                          size: 30, color: Colors.white),
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Welcome back",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 15),
                                        ),
                                        Text(fullname,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChatDetail(compId: widget.compId)),
                              );
                            },
                            child: const FaIcon(FontAwesomeIcons.comment,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              FutureBuilder<int>(
                future: _getJobSeekerCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text("Error fetching job seekers");
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Text("No job seekers registered");
                      }
                      final jobSeekerCount = snapshot.data!;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JsListingPage(compId: widget.compId),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                            children: [
                              Text(
                                "No. of Job Seekers:",
                                style: TextStyle(
                                  fontSize: 18,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.grey[700], // Use your preferred color
                                ),
                              ),
                              const SizedBox(height: 4), // Space between text and number
                              Text(
                                "$jobSeekerCount",
                                style: const TextStyle(
                                  fontSize: 35, // Larger font size for the number
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 5, 52, 92), // Use your preferred color
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
              ),
              SizedBox(height: 15),
            // Fetch and display jobs using StreamBuilder
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('job_postings')
                  .where('posted_by', isEqualTo: widget.compId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading jobs"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No jobs posted yet"));
                }

                final jobs = snapshot.data!.docs;

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index].data() as Map<String, dynamic>;
                    final jobTitle = job['job_title'] ?? 'Unknown Job Title';
                    final jobDescription = job['job_description'] ?? 'Unknown Location';
                    final category = job['category'] ?? 'N/A';

                    return ListTile(
                      title: Text(jobTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Text("Description: $jobDescription\nCategory: $category"),
                      // trailing: Icon(Icons.arrow_forward_ios,
                      //     color: Colors.grey[600]),
                      // onTap: () {
                      //   // Navigate to job details page
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => JobDetailsPage(jobId: jobs[index].id),
                      //     ),
                      //   );
                      // },
                    );
                  },
                );
              },
            ),
            ],
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