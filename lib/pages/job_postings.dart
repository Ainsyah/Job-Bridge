import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_bridge/pages/job_details.dart';
import 'package:job_bridge/pages/saved_jobs.dart';
import 'menu_page.dart';
import 'prof_page.dart';

class JobPostingsPage extends StatefulWidget {
  final String userId;

  const JobPostingsPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<JobPostingsPage> createState() => _JobPostingsPageState();
}

class _JobPostingsPageState extends State<JobPostingsPage> {
  final CollectionReference jobCollection =
      FirebaseFirestore.instance.collection('job_postings');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  late FirebaseAnalytics analytics;
  late FirebaseAnalyticsObserver observer;

  final Map<String, bool> savedJobsCache = {}; // Cache for saved jobs
  String chatId = '';

  @override
  void initState() {
    super.initState();
    analytics = FirebaseAnalytics.instance; // Initialize Firebase Analytics
    observer = FirebaseAnalyticsObserver(analytics: analytics);
  }

  // Fetch user ID of the currently logged-in user
  Future<String?> fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Log event for job view
  void logJobDetailsView(int? jobId, String? jobTitle) async {
    if (jobId == null || jobTitle == null) {
      debugPrint('Invalid jobId or jobTitle for analytics log.');
      return;
    }
    await analytics.logEvent(
      name: 'view_job_details',
      parameters: {
        'job_id': jobId,
        'job_title': jobTitle,
        'user_id': widget.userId,
      },
    );
    debugPrint('Logged view_job_details event for jobId: $jobId, jobTitle: $jobTitle');
  }

  // Save or unsave a job
  Future<void> toggleSaveJob(String jobId) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(widget.userId);

      // Fetch the user document snapshot
      final userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        // If user document does not exist, create it with the 'saved_jobs' field
        await userDoc.set({
          'saved_jobs': [jobId]
        }, SetOptions(merge: true));
      } else {
        // If the user document exists, update 'saved_jobs'
        final savedJobs = userSnapshot.data()?['saved_jobs'] as List<dynamic>? ?? [];
        if (savedJobs.contains(jobId)) {
          // Remove job from 'saved_jobs'
          await userDoc.update({
            'saved_jobs': FieldValue.arrayRemove([jobId])
          });
        } else {
          // Add job to 'saved_jobs'
          await userDoc.update({
            'saved_jobs': FieldValue.arrayUnion([jobId])
          });
        }
      }

      // After toggling, update the saved jobs cache and state
      setState(() {
        savedJobsCache[jobId] = !savedJobsCache.containsKey(jobId) || !savedJobsCache[jobId]!;
      });

    } catch (e) {
      debugPrint('Error saving/removing job: $e');
    }
  }

  // Check if a job is saved
  Future<bool> isJobSaved(String jobId) async {
    if (savedJobsCache.containsKey(jobId)) {
      return savedJobsCache[jobId]!;
    }
    final userDoc = userCollection.doc(widget.userId);
    final userSnapshot = await userDoc.get();
    if (userSnapshot.exists) {
      final savedJobs = (userSnapshot.data() as Map<String, dynamic>)['saved_jobs'] as List<dynamic>? ?? [];
      final isSaved = savedJobs.contains(jobId);
      savedJobsCache[jobId] = isSaved;
      return isSaved;
    }
    return false;
  }

  // Utility function to navigate to a different page
  void navigateToPage(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text('Jobs', style: TextStyle(color: Color.fromARGB(255, 5, 52, 92), fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: jobCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint('Error fetching data: ${snapshot.error}');
            return const Center(child: Text('Error fetching data.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No job postings found.'),
            );
          }

          final jobPostings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: jobPostings.length,
            itemBuilder: (context, index) {
              final job = jobPostings[index].data() as Map<String, dynamic>;
              final documentId = jobPostings[index].id;
              final jobTitle = job['title']?.toString() ?? 'No Title';
              final companyName = job['company_name']?.toString() ?? 'No Company';
              final location = job['location']?.toString() ?? 'No Location';
              final description = job['description'] ?? 'No Description';
              final payPeriod = job['pay_period'] ?? 'No Pay Period';
              final category = job['category'] ?? 'No Category';
              final formattedWorkType = job['formatted_work_type'] ?? 'No Work Type';
              final normalized_salary = job['normalized_salary'] != null
                  ? int.tryParse(job['normalized_salary'].toString()) ?? 0
                  : 0;
              final jobPostingUrl = job['job_posting_url'] ?? '';

              if (jobPostingUrl.isEmpty) {
                debugPrint('Skipping job due to missing URL: $jobTitle');
                return const SizedBox.shrink();
              }

              return GestureDetector(
                onTap: () {
                  // Navigate to JobDetailsPage with job details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailsPage(
                        jobId: documentId,
                        title: jobTitle,
                        companyName: companyName,
                        location: location,
                        description: description,
                        payPeriod: payPeriod,
                        category: category,
                        formattedWorkType: formattedWorkType,
                        normalized_salary: normalized_salary,
                        jobPostingUrl: jobPostingUrl, 
                        userId: widget.userId, 
                        documentId: documentId, chatId: '',
                      ),
                    ),
                  );
                  logJobDetailsView(int.tryParse(documentId), jobTitle);
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Color.fromARGB(255, 233, 244, 255),
                  child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jobTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          companyName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(location, style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          payPeriod,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        FutureBuilder<bool>(
                          future: isJobSaved(documentId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            final isSaved = snapshot.data ?? false;
                            return Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(
                                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                                  color: isSaved ? Colors.black : Colors.grey,
                                ),
                                onPressed: () {
                                  toggleSaveJob(documentId);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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