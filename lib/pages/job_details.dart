import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobDetailsPage extends StatelessWidget {
  final String documentId;
  final String job_id;
  final String userId;
  final String location;
  final String company_id;
  final int medSalary;
  final String pay_period;
  final String formattedWorkType;
  final String formattedExperienceLevel;
  final String skills_desc;
  final bool remote_allowed;
  final double normalizedSalary;
  final String category;

  const JobDetailsPage({
    super.key,
    required this.documentId,
    required this.job_id,
    required this.userId,
    required this.location,
    required this.company_id,
    required this.medSalary,
    required this.pay_period,
    required this.formattedWorkType,
    required this.formattedExperienceLevel,
    required this.skills_desc,
    required this.remote_allowed,
    required this.normalizedSalary,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final CollectionReference jobRef =
        FirebaseFirestore.instance.collection('jobs');
    final CollectionReference companyRef =
        FirebaseFirestore.instance.collection('companies');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 36, 145, 169),
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
                    jobData['title'] ?? 'No Title',
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Location: $location',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Category: $category',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Salary: \$${medSalary.toString()}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Pay Period: $pay_period',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Work Type: $formattedWorkType',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Experience Level: $formattedExperienceLevel',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Skills Required: $skills_desc',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Remote Allowed: ${remote_allowed ? 'Yes' : 'No'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Company Information:',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<DocumentSnapshot>(
                    stream: companyRef.doc(company_id).snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> companySnapshot) {
                      if (companySnapshot.hasError) {
                        return const Text('Error fetching company data');
                      }
                      if (!companySnapshot.hasData || !companySnapshot.data!.exists) {
                        return const Text('Company details not available');
                      }
                      var companyData = companySnapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Name: ${companyData['company_name']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Company Description: ${companyData['description']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Action for applying to the job or other functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 36, 145, 169),
                      fixedSize: const Size(400, 50),
                    ),
                    child: const Text('Apply Now',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
