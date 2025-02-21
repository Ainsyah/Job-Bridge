import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TestJobDetails extends StatelessWidget {
  final String title;
  final String companyName;
  final String location;
  final String description;
  final String payPeriod;
  final String category;
  final String formattedWorkType;
  final int normalized_salary;
  final String jobPostingUrl; // Add jobPostingUrl parameter

  const TestJobDetails({
    required this.title,
    required this.companyName,
    required this.location,
    required this.description,
    required this.payPeriod,
    required this.category,
    required this.formattedWorkType,
    required this.normalized_salary,
    required this.jobPostingUrl, // Add this to constructor
    super.key,
  });

  // Function to launch the URL
  
// Future<void> _launchURL() async {
//   final Uri url = Uri.parse(jobPostingUrl);  // Convert string to Uri
//   if (await canLaunchUrl(url)) {
//     await launchUrl(url);
//   } else {
//     throw 'Could not launch $jobPostingUrl';
//   }
// }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://www.google.com'); // Use Uri.parse
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Launch in an external browser
      );
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Company: $companyName', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Location: $location', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Salary: \$${normalized_salary}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Pay Period: $payPeriod', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Category: $category', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Work Type: $formattedWorkType', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Description:\n$description', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),

              // Apply Button
              ElevatedButton(
                onPressed: _launchURL, // Call the function to open the URL
                child: const Text('Apply Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
