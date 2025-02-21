import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'job_details.dart'; // Import the JobDetailsPage
import 'job_postings.dart';
import 'menu_page.dart';
import 'prof_page.dart';

class SavedJobsPage extends StatefulWidget {
  final String userId;
  
  const SavedJobsPage({Key? key, required this.userId}) : super(key: key);
  
  @override
  State<SavedJobsPage> createState() => _SavedJobsPageState();

}

class _SavedJobsPageState extends State<SavedJobsPage>{
  String chatId = '';

  Future<List<Map<String, dynamic>>> fetchSavedJobs() async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(widget.userId);
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) return [];

    final savedJobs = userSnapshot.data()?['saved_jobs'] as List<dynamic>? ?? [];

    if (savedJobs.isEmpty) return [];

    // Fetch job details for saved jobs
    final jobsQuery = await FirebaseFirestore.instance
        .collection('job_postings')
        .where(FieldPath.documentId, whereIn: savedJobs)
        .get();

    return jobsQuery.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Saved Jobs', style: TextStyle(color: Color.fromARGB(255, 5, 52, 92), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( // Future builder to fetch saved jobs
        future: fetchSavedJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final savedJobs = snapshot.data ?? [];

          if (savedJobs.isEmpty) {
            return const Center(child: Text('No saved jobs yet.'));
          }

          return ListView.builder(
            itemCount: savedJobs.length,
            itemBuilder: (context, index) {
              final job = savedJobs[index];
              final jobId = job['job_id'];
              final jobTitle = job['title'] ?? 'No Title';
              final companyName = job['company_name'] ?? 'No Company';
              final location = job['location'] ?? 'No Location';
              final jobPostingUrl = job['job_posting_url'] ?? '';
              final normalized_salary = job['normalized_salary'] != null
                           ? int.tryParse(job['normalized_salary'].toString()) ?? 0
                           : 0;
              final formattedWorkType = job['formatted_work_type'] ?? 'No Work Type';
              final category = job['category'] ?? 'No Category';
              final payPeriod = job['pay_period'] ?? 'No Pay Period';
              final description = job['description'] ?? 'No Description';

              return GestureDetector(
                onTap: () {
                  // Navigate to JobDetailsPage and pass the jobId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailsPage(
                        userId: widget.userId, // Pass the userId from the parent widget
                        jobId: jobId.toString(), // Job-specific ID
                        title: job['title'] ?? 'No Title',
                        documentId: jobId.toString(),
                        companyName: job['company_name'] ?? 'No Company',
                        location: job['location'] ?? 'No Location',
                        description: job['description'] ?? 'No Description',
                        payPeriod: job['pay_period'] ?? 'No Pay Period',
                        category: job['category'] ?? 'No Category',
                        formattedWorkType: job['formatted_work_type'] ?? 'No Work Type',
                        normalized_salary: normalized_salary,
                        jobPostingUrl: job['job_posting_url'] ?? '',
                        chatId: chatId,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(jobTitle),
                  subtitle: Text('$companyName - $location'),
                  // trailing: IconButton(
                  //   icon: const Icon(Icons.delete, color: Colors.red),
                  //   onPressed: () async {
                  //     await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
                  //       'saved_jobs': FieldValue.arrayRemove([jobId])
                  //     });
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(content: Text('Job removed from saved jobs!')),
                  //     );
                  //   },
                  // ),
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
