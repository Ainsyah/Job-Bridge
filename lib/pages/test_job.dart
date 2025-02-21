import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'test_job_details.dart';

class JobPosting extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Postings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('job_postings').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No job postings found.'));
          }

          final jobPostings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobPostings.length,
            itemBuilder: (context, index) {
              final job = jobPostings[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  // Navigate to JobDetailsPage and pass job details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestJobDetails(
                        title: job['title'] ?? 'No Title',
                        companyName: job['company_name'] ?? 'No Company',
                        location: job['location'] ?? 'No Location',
                        description: job['description'] ?? 'No Description',
                        payPeriod: job['pay_period'] ?? 'No Pay Period',
                        category: job['category'] ?? 'No Category',
                        formattedWorkType: job['formatted_work_type'] ?? 'No work type',
                        normalized_salary: job['normalized_salary'] ?? 0,
                        jobPostingUrl: job['job_posting_url'] ?? '',
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(job['title'] ?? 'No title'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job['company_name'] ?? 'No company'),
                      SizedBox(height: 5),
                      Text(job['pay_period'] ?? 'No pay period available'),
                      SizedBox(height: 5),
                      Text(job['location'] ?? 'No location specified'),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: JobPosting()));
}
