import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_bridge/pages/chat_company_detail.dart';
import 'package:job_bridge/pages/chat_user.dart';
import 'package:job_bridge/pages/model_manager.dart';
import 'job_details.dart';
import 'job_postings.dart';
import 'prof_page.dart';
import 'profile_page.dart';
import 'saved_jobs.dart';

class MenuPage extends StatefulWidget {
  final String userId;

  const MenuPage({
    Key? key, required this.userId,
  }) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final CollectionReference collRef =
      FirebaseFirestore.instance.collection('job_postings');
  late Future<List<String>> recommendedJobIdsFuture;
  String searchQuery = '';
  String selectedCategory = 'All Categories';
  String chatId = '';

  @override
  void initState() {
    super.initState();
    recommendedJobIdsFuture = fetchRecommendedJobIds();
    predictJobRecommendations();
  }

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<List<String>> getCategories() async {
    final snapshot = await collRef.get();
    final categories = <String>['All Categories'];
    for (var doc in snapshot.docs) {
      final job = doc.data() as Map<String, dynamic>;
      final category = job['category'] ?? 'Uncategorized';
      if (!categories.contains(category)) {
        categories.add(category);
      }
    }
    return categories;
  }

Future<List<String>> fetchRecommendedJobIds() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('user_recommendations')
        .doc(widget.userId)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return List<String>.from(data['recommended_jobs'] ?? []);
    } else {
      return [];
    }
  } catch (e) {
    debugPrint('Error fetching recommended job IDs: $e');
    return [];
  }
}

  Future<void> predictJobRecommendations() async {
  try {
    // Step 1: Fetch user skills
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    if (!userDoc.exists) {
      throw Exception("User not found");
    }
    final userSkills = List<String>.from(userDoc['skills'] ?? []);
    print("User Skills: $userSkills"); // Debugging log

    // Step 2: Fetch job postings and filter based on the skills
    final jobSnapshot = await FirebaseFirestore.instance.collection('job_postings').get();
    print("Job Postings Count: ${jobSnapshot.docs.length}"); // Debugging log
    List<String> recommendedJobIds = [];

    for (var doc in jobSnapshot.docs) {
      final job = doc.data() as Map<String, dynamic>;
      final jobTitle = job['title']?.toLowerCase() ?? '';
      final jobDescription = job['description']?.toString().toLowerCase() ?? '';
      
      // Simple keyword matching (you can use a more sophisticated matching algorithm)
      bool matches = false;
      for (var skill in userSkills) {
        if (jobTitle.contains(skill.toLowerCase()) || jobDescription.contains(skill.toLowerCase())) {
          matches = true;
          break;
        }
      }

      if (matches) {
        recommendedJobIds.add(doc.id); // Add job to recommended list
      }
    }

    print("Recommended Job IDs: $recommendedJobIds"); // Debugging log

    // Step 3: Update Firestore with the recommended job IDs for the user
    await FirebaseFirestore.instance.collection('user_recommendations').doc(widget.userId).set({
      'recommended_jobs': recommendedJobIds,
    }, SetOptions(merge: true));

    // Step 4: Refresh the recommended jobs
    setState(() {
      recommendedJobIdsFuture = fetchRecommendedJobIds();
    });
  } catch (e) {
    debugPrint("Error predicting job recommendations: $e");
  }
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
            children: [
              // User Greeting and Profile Section
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
                                        ProfPage(userId: widget.userId)),
                              );
                            },
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.userId)
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
                                    userData['fullname'] ?? 'No Name';

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
                                        ChatCompanyDetail(userId: widget.userId)),
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

              // Search Field
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search job titles or companies...',
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.white),
                    fillColor: const Color.fromARGB(255, 5, 52, 92),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),

              SizedBox(height: 15),

              // Filter Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FutureBuilder<List<String>>(
                      future: getCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Text('Error');
                        }
                        final categories = snapshot.data!;
                        return DropdownButton<String>(
                          value: selectedCategory,
                          items: categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(
                                category, 
                                style: TextStyle(color: Color.fromARGB(255, 5, 52, 92)),
                                ),
                                );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategory = newValue!;
                            });
                          },
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 8.0), // Space between text and icon
                            child: const Icon(Icons.filter_list, color: Color.fromARGB(255, 5, 52, 92)),
                          ),
                          isDense: true, // Optional: Make the dropdown compact
                          dropdownColor:  Colors.white,
                          style: TextStyle(color: Color.fromARGB(255, 5, 52, 92)),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Job Recommendations Section
            FutureBuilder<List<String>>(
              future: fetchRecommendedJobIds(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      children: const [
                        Text(
                          'No recommended jobs at the moment.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final recommendedJobIds = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recommendedJobIds.length,
                  itemBuilder: (context, index) {
                    final documentId = recommendedJobIds[index];
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('job_postings')  // Ensure this collection name is correct
                          .doc(documentId)
                          .get(),
                      builder: (context, jobSnapshot) {
                        if (jobSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (jobSnapshot.hasError ||
                            !jobSnapshot.hasData ||
                            !jobSnapshot.data!.exists) {
                          return const SizedBox();
                        }

                        final jobData = jobSnapshot.data!.data() as Map<String, dynamic>;
                        final job_id = jobData['job_id'].toString();
                        final jobTitle = jobData['title'] ?? 'No Title';
                        final companyName = jobData['company_name'] ?? 'No Company';
                        final location = jobData['location'] ?? 'No Location';
                        final normalized_salary = jobData['normalized_salary'] != null
                           ? int.tryParse(jobData['normalized_salary'].toString()) ?? 0
                           : 0;

                        return ListTile(
                          title: Text(jobTitle),
                          subtitle: Text('$companyName • $location'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobDetailsPage(
                                  userId: widget.userId,
                                  documentId: documentId,
                                  jobId: job_id,
                                  title: jobTitle,
                                  companyName: companyName,
                                  location: location,
                                  description: jobData['description'] ?? '',
                                  payPeriod: jobData['pay_period'] ?? '',
                                  category: jobData['category'] ?? '',
                                  formattedWorkType: jobData['formatted_work_type'] ?? '',
                                  normalized_salary: normalized_salary,
                                  jobPostingUrl: jobData['job_posting_url'] ?? '',
                                  chatId: chatId,
                                ),
                              ),
                            );
                          },
                        );
                      },
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
